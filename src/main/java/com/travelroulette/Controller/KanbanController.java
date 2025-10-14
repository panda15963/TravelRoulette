package com.travelroulette.Controller;

import com.travelroulette.Dto.Kanban.KanBanDto;
import com.travelroulette.Dto.Kanban.KanBanDto.TaskStatus;
import com.travelroulette.Dto.Kanban.KanBanDto.Priority;
import com.travelroulette.Service.KanbanService;
// ✅ 네 프로젝트의 AuthenticatedUser 경로로 맞춰주세요
import com.travelroulette.Dto.User.AuthenticatedUser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.util.*;

import com.google.gson.*;


import java.util.List;

@WebServlet("/kanban")
public class KanbanController extends HttpServlet {

    private KanbanService service;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        service = new KanbanService();
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>)
                        (src, typeOfSrc, context) -> new JsonPrimitive(src == null ? null : src.toString()))
                .registerTypeAdapter(LocalDateTime.class, (JsonDeserializer<LocalDateTime>)
                        (json, typeOfT, context) -> json == null || json.isJsonNull() ? null : LocalDateTime.parse(json.getAsString()))
                .setPrettyPrinting()
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doProcess(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doProcess(req, resp);
    }

    private void doProcess(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        String action = req.getParameter("action");
        HttpSession session = req.getSession(false);

        // ✅ 세션에서 userId 가져오기
        String userId = "ryeol3";

        JsonObject result = new JsonObject();

        // ✅ 로그인 여부 검사
        if (userId == null || userId.isBlank()) {
            result.addProperty("success", false);
            result.addProperty("error", "로그인이 필요합니다.");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        try {
            switch (action) {
                case "list":
                    List<KanBanDto> list = service.list(userId);
                    result.add("data", gson.toJsonTree(list));
                    break;

                case "create":
                    String desc = req.getParameter("description");
                    String status = req.getParameter("status");
                    String priority = req.getParameter("priority");
                    String dueDate = req.getParameter("dueDate");
                    Integer newId = service.create(userId, desc, status, priority, dueDate);
                    result.addProperty("success", newId != null);
                    result.addProperty("newId", newId);
                    break;

                case "update":
                    int taskId = Integer.parseInt(req.getParameter("taskId"));
                    String newStatus = req.getParameter("status");
                    String newDesc = req.getParameter("description");
                    String newPr = req.getParameter("priority");
                    int updated = service.update(userId, taskId, newStatus, newDesc, newPr);
                    result.addProperty("success", updated > 0);
                    break;

                case "delete":
                    int delId = Integer.parseInt(req.getParameter("taskId"));
                    int deleted = service.delete(userId, delId);
                    result.addProperty("success", deleted > 0);
                    break;

                case "reorder":
                    String reorderStatus = req.getParameter("status");
                    String[] ids = req.getParameterValues("orderedIds[]");
                    if (ids == null) throw new IllegalArgumentException("orderedIds[] is required");
                    List<Integer> orderedList = java.util.Arrays.stream(ids)
                            .map(Integer::parseInt).toList();
                    service.reorder(userId, reorderStatus, orderedList);
                    result.addProperty("success", true);
                    break;

                case "move":
                    int moveId = Integer.parseInt(req.getParameter("taskId"));
                    String from = req.getParameter("from");
                    String to = req.getParameter("to");
                    int newOrder = Integer.parseInt(req.getParameter("newOrder"));
                    service.move(userId, moveId, from, to, newOrder);
                    result.addProperty("success", true);
                    break;

                default:
                    result.addProperty("error", "알 수 없는 action: " + action);
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("error", e.getMessage());
        }

        resp.getWriter().write(gson.toJson(result));
    }
    
    
}

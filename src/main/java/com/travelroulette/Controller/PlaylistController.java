package com.travelroulette.Controller;

import com.travelroulette.Dao.PlaylistDao;         // ✅ Dao는 최상위 Dao 패키지
import com.travelroulette.Dto.Music.Track;          // ✅ DTO는 Dto.Music
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.util.List;


@WebServlet("/playlist/*")
public class PlaylistController extends HttpServlet {
    private final PlaylistDao dao = new PlaylistDao();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        final String path = req.getPathInfo();
        final String sessionId = req.getSession().getId();

        // ✅ 플레이리스트에 곡 추가
        if ("/add".equals(path)) {
            System.out.println("[🎵 PlaylistController] /playlist/add (session=" + sessionId + ")");

            try (BufferedReader reader = req.getReader()) {
                Track track = gson.fromJson(reader, Track.class);
                dao.addTrack(sessionId, track);
            }

            // ✅ 현재 세션의 곡 목록 디버그 출력
            List<Track> list = dao.getPlaylist(sessionId);
            System.out.println("  └ 현재 곡 수: " + list.size());
            for (Track t : list) {
                System.out.println("     - " + t.getTitle() + " / " + t.getArtist());
                System.out.println("       previewUrl=" + t.getPreviewUrl());
                System.out.println("       albumCover=" + t.getAlbumCover());
            }

            // ✅ JSON 응답 수정 (쉼표 추가)
            resp.getWriter().write("{\"status\":true, \"message\":\"added\"}");
            return;
        }

        // ✅ 플레이리스트 비우기
        if ("/clear".equals(path)) {
            dao.clearPlaylist(sessionId);
            System.out.println("[🗑 PlaylistController] /playlist/clear (session=" + sessionId + ")");
            resp.getWriter().write("{\"status\":true, \"message\":\"cleared\"}");
            return;
        }

        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        final String path = req.getPathInfo();
        final String sessionId = req.getSession().getId();
        resp.setContentType("application/json; charset=UTF-8");

        // ✅ 리스트 요청 처리
        if ("/list".equals(path)) {
            List<Track> list = dao.getPlaylist(sessionId);
            System.out.println("[📜 PlaylistController] /playlist/list -> " + list.size() + " tracks (session=" + sessionId + ")");
            resp.getWriter().write(gson.toJson(list));
            return;
        }

        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
    }
}
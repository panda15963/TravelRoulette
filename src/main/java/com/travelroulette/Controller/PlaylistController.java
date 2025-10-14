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

        if ("/add".equals(path)) {
            System.out.println("[🎵 PlaylistController] /playlist/add (session=" + sessionId + ")");

            // JSON → Track 매핑
            try (BufferedReader reader = req.getReader()) {
                Track track = gson.fromJson(reader, Track.class);
                dao.addTrack(sessionId, track);
            }

            // 디버그: 현재 세션 리스트 출력
            List<Track> list = dao.getPlaylist(sessionId);
            System.out.println("  └ 현재 곡 수: " + list.size());
            for (Track t : list) {
                System.out.println("     - " + t.getTitle() + " / " + t.getArtist());
                System.out.println("       previewUrl=" + t.getPreviewUrl());
                System.out.println("       albumCover=" + t.getAlbumCover());
            }

            resp.getWriter().write("{\"status\":\"added\"}");
            return;
        }

        if ("/clear".equals(path)) {
            dao.clearPlaylist(sessionId);
            System.out.println("[🗑 PlaylistController] /playlist/clear (session=" + sessionId + ")");
            resp.getWriter().write("{\"status\":\"cleared\"}");
            return;
        }

        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        final String path = req.getPathInfo();
        final String sessionId = req.getSession().getId();
        resp.setContentType("application/json; charset=UTF-8");

        if ("/list".equals(path)) {
            List<Track> list = dao.getPlaylist(sessionId);
            System.out.println("[📜 PlaylistController] /playlist/list -> " + list.size() + " tracks (session=" + sessionId + ")");
            resp.getWriter().write(gson.toJson(list));
            return;
        }

        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
    }
}

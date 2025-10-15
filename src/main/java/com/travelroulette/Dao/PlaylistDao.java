package com.travelroulette.Dao;

import com.travelroulette.Dto.Music.Track;
import java.util.*;

/**
 * PlaylistDao
 * 🎵 세션 단위로 곡 정보를 임시 저장하는 DAO
 * (현재는 메모리 기반으로, 나중에 JDBC/DB 버전으로 확장 가능)
 */
public class PlaylistDao {

    // ✅ 세션별 플레이리스트 임시 저장소 (전역 Map)
    private static final Map<String, List<Track>> playlistMap = new HashMap<>();

    /**
     * 개별 곡 추가
     */
    public void addTrack(String sessionId, Track track) {
        playlistMap.computeIfAbsent(sessionId, k -> new ArrayList<>()).add(track);
        System.out.println("[DAO] 세션 " + sessionId + " → 곡 추가: " + track.getTitle());
    }

    /**
     * 세션별 플레이리스트 조회
     */
    public List<Track> getPlaylist(String sessionId) {
        return playlistMap.getOrDefault(sessionId, new ArrayList<>());
    }

    /**
     * 세션별 플레이리스트 전체 비우기
     */
    public void clearPlaylist(String sessionId) {
        playlistMap.remove(sessionId);
        System.out.println("[DAO] 세션 " + sessionId + " → 플레이리스트 비움");
    }
}

package com.travelroulette.Dto.Music;

public class Track {
    private String title;
    private String artist;
    private String previewUrl;
    private String albumCover;

    public Track() {}

    public Track(String title, String artist, String previewUrl, String albumCover) {
        this.title = title;
        this.artist = artist;
        this.previewUrl = previewUrl;
        this.albumCover = albumCover;
    }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getArtist() { return artist; }
    public void setArtist(String artist) { this.artist = artist; }

    public String getPreviewUrl() { return previewUrl; }
    public void setPreviewUrl(String previewUrl) { this.previewUrl = previewUrl; }

    public String getAlbumCover() { return albumCover; }
    public void setAlbumCover(String albumCover) { this.albumCover = albumCover; }
}

package com.travelroulette.Utils;

import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManagerBuilder;
import org.apache.hc.client5.http.io.HttpClientConnectionManager;
import org.apache.hc.client5.http.ssl.SSLConnectionSocketFactory;
import org.apache.hc.client5.http.ssl.TrustAllStrategy;
import org.apache.hc.core5.ssl.SSLContexts;

import javax.net.ssl.SSLContext;

public class HttpClientHelper {

    public static CloseableHttpClient getSslBypassClient() {
        try {
            SSLContext sslContext = SSLContexts.custom()
                    .loadTrustMaterial(null, new TrustAllStrategy())
                    .build();

            SSLConnectionSocketFactory sslSocketFactory = new SSLConnectionSocketFactory(sslContext);

            HttpClientConnectionManager connectionManager = PoolingHttpClientConnectionManagerBuilder.create()
                    .setSSLSocketFactory(sslSocketFactory)
                    .build();

            return HttpClients.custom()
                    .setConnectionManager(connectionManager)
                    .build();

        } catch (Exception e) {
            e.printStackTrace();
            return HttpClients.createDefault();
        }
    }
}
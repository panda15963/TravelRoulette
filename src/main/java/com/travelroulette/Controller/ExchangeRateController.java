package com.travelroulette.Controller;

import com.google.gson.Gson;
import com.travelroulette.Dto.Country.CountryDto;
import com.travelroulette.Service.ExchangeRateService;
import com.travelroulette.Utils.HttpClientHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.cookie.BasicCookieStore;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.HttpHeaders;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.apache.hc.core5.net.URIBuilder;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@WebServlet("/chart/exchange/*")
public class ExchangeRateController extends HttpServlet {

    public ExchangeRateController() { super(); }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestURI  = request.getRequestURI();
        String contextPath = request.getContextPath();
        String command     = requestURI.substring(contextPath.length());

        System.out.println("[ExchangeRate] command = " + command);

        try {

            /*
            if (command.equals("/chart/exchange/view.do")) {
                ExchangeRateService svc = new ExchangeRateService();
                List<CountryDto> countries = svc.getAllCountries();

                request.setAttribute("countries", countries);
                request.getRequestDispatcher("/pages/chart.jsp").forward(request, response);

                return;
            }
             */

            if (command.equals("/chart/exchange/view.do")) {
                request.getRequestDispatcher("/pages/chart.jsp").forward(request, response);
                return;
            }

            else if (command.equals("/chart/exchange/countries.do")) {
                ExchangeRateService svc = new ExchangeRateService();
                List<CountryDto> countries = svc.getAllCountries();

                //국가 목록을 JSON으로 변환
                Gson gson = new Gson();
                String jsonCountries = gson.toJson(countries);

                //JSON 응답
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write(jsonCountries);
                return;
            }

            //환율 API 호출
            /*
            else if (command.equals("/chart/exchange/api.do")) {
                try {
                    String searchDate = request.getParameter("searchdate");
                    String authKey = request.getParameter("authkey");

                    URI apiUri = new URIBuilder("https://www.koreaexim.go.kr/site/program/financial/exchangeJSON")
                            .addParameter("authkey", authKey)
                            .addParameter("searchdate", searchDate)
                            .addParameter("data", "AP01")
                            .build();

                    BasicCookieStore cookieStore = new BasicCookieStore();
                    try (CloseableHttpClient httpClient = HttpClients.custom()
                            .disableRedirectHandling() // ← 핵심: 자동 리다이렉트 끔
                            .setDefaultCookieStore(cookieStore)
                            .build()) {

                        HttpGet httpGet = new HttpGet(apiUri);
                        httpGet.addHeader(HttpHeaders.ACCEPT, "application/json");
                        httpGet.addHeader(HttpHeaders.USER_AGENT, "Mozilla/5.0");

                        try (CloseableHttpResponse httpResponse = httpClient.execute(httpGet)) {
                            int statusCode = httpResponse.getCode();

                            if (statusCode >= 300 && statusCode < 400) {
                                Header locationHeader = httpResponse.getFirstHeader("Location");
                                String redirectUrl = (locationHeader != null) ? locationHeader.getValue() : "(none)";
                                System.err.println("Upstream redirect to: " + redirectUrl);
                                response.sendError(HttpServletResponse.SC_BAD_GATEWAY,
                                        "Upstream redirected unexpectedly: " + redirectUrl);
                                return;
                            }

                            HttpEntity entity = httpResponse.getEntity();
                            String responseJson = EntityUtils.toString(entity);

                            response.setContentType("application/json; charset=UTF-8");
                            response.getWriter().write(responseJson);
                        }
                    }
                    return;

                } catch (Exception e) {
                    System.err.println("API 호출 중 예외 발생 in ExchangeRateController");
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "API 호출 중 서버 내부 오류 발생");
                    return;
                }
            }

             */


            else if (command.equals("/chart/exchange/api.do")) {
                try {
                    String searchDate = request.getParameter("searchdate");
                    String authKey = request.getParameter("authkey");
                    String apiUrl = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=" + authKey + "&searchdate=" + searchDate + "&data=AP01";
                    //String apiUrl = "https://www.koreaexim.go.kr/site/program/financial/exchangeReport?authkey=" + authKey + "&searchdate=" + searchDate + "&data=AP01";

                    try (CloseableHttpClient httpClient = com.travelroulette.Utils.HttpClientHelper.getSslBypassClient()) {

                        HttpGet httpGet = new HttpGet(apiUrl);

                        try (CloseableHttpResponse httpResponse = httpClient.execute(httpGet)) {

                            HttpEntity entity = httpResponse.getEntity();
                            String responseJson = EntityUtils.toString(entity);

                            response.setContentType("application/json; charset=UTF-8");
                            response.getWriter().write(responseJson);
                        }
                    }

                    return;

                } catch (Exception e) {
                    System.out.println("API 호출 중 예외 발생 in ExchangeRateController");
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "API 호출 중 서버 내부 오류 발생");
                    return;
                }
            }




            response.sendError(HttpServletResponse.SC_NOT_FOUND);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private String n(String s) { return (s == null) ? "" : s.trim(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.travelroulette.Dto.User.AuthenticatedUser" %>
<%
    /*
     * 인증 사용자 정보 초기화
     *
     * 목적: navbar.jsp와 sidebar.jsp에서 로그인 상태를 확인하기 위해 사용
     *
     * 왜 이렇게 구현했는가?
     * 1. navbar와 sidebar는 반응형 웹을 위해 존재 (데스크톱=navbar, 모바일=sidebar)
     * 2. 같은 페이지에 둘 다 include되지만 동시에 표시되지는 않음
     * 3. JSP 컴파일 시 두 파일이 하나의 서블릿으로 합쳐지면서 변수 중복 선언 문제 발생
     *
     * 해결 방법:
     * - AuthInit.jsp: session에서 사용자 정보를 가져와 request 속성에 저장 (딱 한 번만 실행)
     * - navbar.jsp/sidebar.jsp: request에서 authUser를 가져와서 각자의 로컬 변수로 선언
     * - 로컬 변수는 각 파일의 스크립틀릿 스코프 내에서만 존재하므로 중복 문제 없음
     *
     * 주의사항:
     * - 이 파일은 navbar.jsp와 sidebar.jsp 양쪽에서 include됨
     * - 첫 번째 include에서만 실제로 초기화하고, 두 번째는 이미 설정된 값 사용
     */

    // 중복 초기화 방지: request에 이미 저장되어 있으면 다시 설정하지 않음
    if (request.getAttribute("authUser") == null) {
        // 세션에서 로그인한 사용자 정보 가져오기
        AuthenticatedUser user = (AuthenticatedUser) session.getAttribute("authenticatedUser");
        // request 속성에 저장 (이 요청 범위 내에서 공유됨)
        request.setAttribute("authUser", user);
    }
%>


<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>TripWiki</title>
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="../assets/favicon.ico?v=2"/>
    <link href="../css/styles.css" rel="stylesheet"/>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body id="pageBody" class="d-flex flex-column h-100 bg-white text-dark" data-mode="light">

<%@ include file="/Common/navbar.jsp" %>
<%@ include file="/Common/sidebar.jsp" %>

<div id="nav-spacer" aria-hidden="true"></div>

<div class="container flex-grow-1">
    <!-- 상단 여백 -->
    <div class="py-4"></div>

    <!-- 가운데 정렬 래퍼 -->
    <div class="mx-auto" style="width:100%; max-width:900px;">
        <h1 class="h3 fw-bold text-primary mb-4 text-center">실시간 환율 차트</h1>

        <div class="p-3 border rounded bg-light mb-4">
            <div class="row g-3 align-items-end justify-content-center">
                <div class="col-12 col-md-6">
                    <label for="currency-select" class="form-label fw-semibold">통화 선택</label>
                    <select id="currency-select" class="form-select">
                        <c:forEach var="country" items="${countries}">
                            <option value="" disabled selected>--- 국가를 선택해주세요 ---</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-6 col-md-3">
                    <label for="period-select" class="form-label fw-semibold">기간</label>
                    <select id="period-select" class="form-select">
                        <option value="7">최근 7일</option>
                        <option value="14">최근 14일</option>
                        <option value="30">최근 1개월</option>
                    </select>
                </div>

                <div class="col-6 col-md-3 d-grid">
                    <button id="refresh-chart-btn" class="btn btn-info text-white fw-semibold">새로고침</button>
                </div>
            </div>
        </div>

        <!-- 차트 영역 -->
        <div class="border rounded p-3">
            <div id="chart-container" style="min-height:320px;">
                <p class="text-center text-muted" style="line-height: 320px;">통화와 기간을 선택하고 새로고침 버튼을 눌러주세요.</p>

                <%-- d3.js 차트 --%>

            </div>
        </div>
    </div>

    <!-- 하단 여백 -->
    <div class="py-5"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/features/darkmode.js"></script>
<script src="https://d3js.org/d3.v7.min.js"></script>

<script>
    //네비 높이에 맞춰 상단 스페이서 높이 자동 설정
    document.addEventListener('DOMContentLoaded', function () {
        const nav = document.querySelector('.navbar');
        const spacer = document.getElementById('nav-spacer');
        if (nav && spacer) {
            spacer.style.height = (nav.offsetHeight + 8) + 'px'; //여백 8px 추가
            //네비 높이가 반응형으로 바뀔 때도 업데이트
            window.addEventListener('resize', () => {
                spacer.style.height = (nav.offsetHeight + 8) + 'px';
            });
        }
    });
</script>

<script>
    window.onload = function() {
        fetch('${pageContext.request.contextPath}/chart/exchange/countries.do')
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('국가 목록을 가져오는 데 실패했습니다.');
                }
                return response.json();
            })
            .then(function(countries) {
                const currencySelect = document.getElementById('currency-select');
                const refreshBtn = document.getElementById('refresh-chart-btn');

                currencySelect.innerHTML = ''; //기존 <option>들 모두 삭제

                const placeholder = document.createElement('option');
                placeholder.value = '';
                placeholder.textContent = '--- 국가를 선택해주세요 ---';
                placeholder.selected = true;
                currencySelect.appendChild(placeholder);

                //서버에서 받아온 국가 목록을 option으로 추가
                countries.forEach(function(country) {
                    const option = document.createElement('option');
                    option.value = country.currency;
                    option.textContent = country.countryNameKor + ' (' + country.currency + ')';
                    currencySelect.appendChild(option);
                });

                //버튼 활성화/비활성화 로직
                refreshBtn.disabled = true;
                currencySelect.addEventListener('change', () => {
                    refreshBtn.disabled = currencySelect.value === '';
                });
            })
            .catch(function(error) {
                console.error('국가 목록 로딩 중 오류:', error);
                document.getElementById('currency-select').innerHTML = '<option>목록 로딩 실패</option>';
            });
    };



    //새로고침 버튼 클릭
    document.getElementById('refresh-chart-btn').addEventListener('click', fetchDataAndLog);

    function fetchDataAndLog() {
        const currencySelect = document.getElementById('currency-select');
        const currency = currencySelect.value;

        if (!currency) {
            document.getElementById('chart-container').innerHTML =
                '<p class="text-center text-muted">먼저 통화를 선택하세요.</p>';
            return;
        }

        const period = document.getElementById('period-select').value;
        const authKey = 'zZeeAYymZe5l9Kx867xmt6vFsYhw9KmH';

        document.getElementById('chart-container').innerHTML = '<p class="text-center text-muted">환율 정보를 불러오는 중...</p>';

        const dates = [];
        let currentDate = new Date();
        while (dates.length < period) {
            const dayOfWeek = currentDate.getDay();
            if (dayOfWeek !== 0 && dayOfWeek !== 6) {
                const searchDate = currentDate.getFullYear() +
                    ('0' + (currentDate.getMonth() + 1)).slice(-2) +
                    ('0' + currentDate.getDate()).slice(-2);
                dates.push(searchDate);
            }
            currentDate.setDate(currentDate.getDate() - 1);
        }
        dates.reverse();

        const promises = dates.map(function(date) { // `date`는 "YYYYMMDD" 형식의 문자열
            const url = '${pageContext.request.contextPath}/chart/exchange/api.do?authkey=' + authKey + '&searchdate=' + date;

            return fetch(url)
                .then(response => response.json())
                .then(currencyItems => {
                    return currencyItems.map(item => {
                        item.request_date = date;
                        return item;
                    });
                });
        });

        Promise.all(promises)
            .then(function(results) {
                const chartData = results.flat()
                    .filter(function(item) { return item.result === 1 && item.cur_unit === currency; })
                    .map(function(item) {
                        const year = parseInt(item.request_date.substring(0, 4));
                        const month = parseInt(item.request_date.substring(4, 6)) - 1;
                        const day = parseInt(item.request_date.substring(6, 8));

                        return {
                            date: new Date(year, month, day),
                            rate: parseFloat(item.deal_bas_r.replace(/,/g, ''))
                        };
                    })
                    .sort((a, b) => a.date - b.date);

                if (chartData.length === 0) {
                    document.getElementById('chart-container').innerHTML = '<p class="text-center text-danger">선택하신 기간에 해당 통화의 환율 정보가 없습니다. (주말/공휴일 제외)</p>';
                } else {
                    drawChart(chartData);
                }
            })
            .catch(function(error) {
                console.error('API 호출 중 오류 발생:', error);
                document.getElementById('chart-container').innerHTML = '<p class="text-center text-danger">환율 정보를 가져오는 데 실패했습니다. F12 콘솔을 확인해주세요.</p>';
            });
    }

        /**
         * d3.js를 사용하여 선 그래프를 그리는 함수
         * @param {Array} data - 차트에 사용할 데이터 배열 [{date: Date, rate: number}]
         */
        function drawChart(data) {
            //기존에 그려진 차트가 있다면 삭제
            d3.select("#chart-container").select("svg").remove();
            document.getElementById('chart-container').innerHTML = ''; // '로딩 중' 메시지 삭제

            //차트의 크기와 여백 설정
            const margin = {top: 20, right: 50, bottom: 30, left: 70};
            const width = document.getElementById('chart-container').clientWidth - margin.left - margin.right;
            const height = 320 - margin.top - margin.bottom;

            //차트가 그려질 SVG 캔버스를 #chart-container 안에 생성
            const svg = d3.select("#chart-container")
                .append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

            //범위 설정
            const x = d3.scaleTime()
                .domain(d3.extent(data, function(d) { return d.date; }))
                .range([ 0, width ]);

            const y = d3.scaleLinear()
                .domain([d3.min(data, function(d) { return d.rate; }) * 0.995, d3.max(data, function(d) { return d.rate; }) * 1.005]) // Y축 범위 미세 조정
                .range([ height, 0 ]);

            //X축과 Y축 그리기
            svg.append("g")
                .attr("transform", "translate(0," + height + ")")
                .call(d3.axisBottom(x).ticks(7).tickFormat(d3.timeFormat("%m-%d")));

            svg.append("g")
                .call(d3.axisLeft(y).tickFormat(function(d) { return d.toLocaleString() + "원"; }));

            //선
            svg.append("path")
                .datum(data)
                .attr("fill", "none")
                .attr("stroke", "#0dcaf0") // info color
                .attr("stroke-width", 2.5)
                .attr("d", d3.line()
                    .x(function(d) { return x(d.date); })
                    .y(function(d) { return y(d.rate); })
                );

            //점
            svg.selectAll("myCircles")
                .data(data)
                .enter()
                .append("circle")
                .attr("fill", "#0dcaf0")
                .attr("stroke", "none")
                .attr("cx", function(d) { return x(d.date); })
                .attr("cy", function(d) { return y(d.rate); })
                .attr("r", 4);
        }

</script>




</body>
</html>
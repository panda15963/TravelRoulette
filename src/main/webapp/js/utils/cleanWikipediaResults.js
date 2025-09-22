export function cleanWikipediaResults(cities, excludePatterns) {
    return cities
        .map(c => {
            let title = c.title;

            // 1. Category: 제거
            if (title.startsWith("Category:")) {
                title = title.replace(/^Category:/, "");
            }
            // 2. Template: 제거 → null 처리
            if (title.startsWith("Template:")) {
                return null;
            }
            // 3. , 나라명 잘라내기
            if (title.includes(",")) {
                title = title.split(",")[0].trim();
            }
            // 4. (city), (town), (neighborhood) 같은 괄호 설명 제거
            title = title.replace(/\s*\(.*?\)/g, "").trim();

            // 5. excludePatterns 와 매칭되는 경우 제거
            if (excludePatterns.some(p => title.includes(p))) {
                return null;
            }

            return { ...c, title };
        })
        .filter(Boolean); // null 제거
}
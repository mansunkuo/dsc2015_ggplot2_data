library(XML)
library(whisker)
library(data.table)
stations = list(臺北 = "466920", 
                臺中 = "467490",
                高雄 = "467440",
                花蓮 = "466990"
                )
months = substr(as.character(seq.Date(as.Date("2012-06-01"), as.Date("2015-05-01"), by="months")), 1, 7)
tempurl = "http://e-service.cwb.gov.tw/HistoryDataQuery/MonthDataController.do?command=viewMain&station={{station}}&datepicker={{month}}"

for (i in 1:length(stations)) {
    dts = list()
    station_name = names(stations[i])
    station = stations[[i]]
    for (month in months) {
        url =whisker.render(tempurl)
        print(url)
        tables = readHTMLTable(url, encoding="UTF-8", stringsAsFactor = FALSE)
        temptable = tables$MyTable
        colnames(temptable) = as.vector(as.matrix(temptable[2,]))
        temptable = temptable[3:nrow(temptable), ]
        filename = whisker.render("data/{{station_name}}_{{month}}.csv")
        print(filename)
        write.csv(temptable, filename, row.names = FALSE)
        Sys.sleep(rpois(1, 3))
    }
}

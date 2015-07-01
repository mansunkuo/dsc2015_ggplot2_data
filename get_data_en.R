# generate data without Chinese header
library(whisker)
stations_en = list(Taipei = "臺北", 
                   Taichung = "臺中",
                   Kaohsiung = "高雄",
                   Hualien = "花蓮")
months = substr(as.character(seq.Date(as.Date("2012-06-01"), as.Date("2015-05-01"), by="months")), 1, 7)
for (i in 1:length(stations_en)) {
    station_name_en = names(stations_en[i])
    station_name_tw = stations_en[[i]]
    for (month in months) {
        filename_in = whisker.render("data/{{station_name_tw}}_{{month}}.csv")
        filename_out = whisker.render("data/{{station_name_en}}_{{month}}.csv")
        temptable = read.csv(filename_in)
        header_all = colnames(temptable)
        header_en = gsub("^[^A-Z]*|A型蒸發量\\.mm\\.|X10分鐘最大降水量|\\.mm\\.|X10分鐘最大降水起始時間|(\\.)*LST(\\.)*|MJ\\.*|Pa\\.*", "", header_all)
        colnames(temptable) = header_en
        write.csv(temptable, filename_out, row.names = FALSE)
    }
}

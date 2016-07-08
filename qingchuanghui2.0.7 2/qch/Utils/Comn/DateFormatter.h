

#import <Foundation/Foundation.h>

#define def_YearMonthDay                            @"yyyyMMdd"

#define def_YearMonthDayWeek                        @"yyyy-MM-dd EEEE"
#define def_YearMonthDayWeekChn                     @"yyyy年MM月dd日 EEEE"

#define def_YearMonthDayWeek_DF                     @"yyyy-MM-dd EE"
#define def_YearMonthDayWeekChn_DF                  @"yyyy年MM月dd日 EE"
#define def_Year1Month1DayWeekChn_DF                @"yyyy年M月d日 EE"
#define def_Year1Month1Day_DF                       @"yyyy年M月d日"

#define def_YearMonthDay_DF                         @"yyyy-MM-dd"
#define def_YearMonthDayChn_DF                      @"yyyy年MM月dd日"

#define def_YearMonthDayHourMinute_DF               @"yyyy-MM-dd HH:mm"
#define def_YearMonthDayHourMinuteChn_DF            @"yyyy年MM月dd日 HH:mm"

#define def_YearMonthDayHourMinuteSec_DF            @"yyyy-MM-dd HH:mm:ss"
#define def_YearMonthDayHourMinuteSecChn_DF         @"yyyy年MM月dd日 HH:mm:ss"
#define def_YearMonthDayHourMinuteSec_              @"yyyy/MM/dd HH:mm:ss"
#define def_YearMonthDay_                           @"yyyy/MM/dd"
#define def_YearMobth                               @"yyyy.MM"

#define def_MonthDay_DF                             @"MM/dd"
#define def_MonthDayPoint_DF                        @"MM.dd"
#define def_MonthDayLine_DF                         @"MM-dd"
#define def_MonthDayChn_DF                          @"MM月dd日"

#define def_YearWeekChn_DF                          @"yyyy年 EEEE"

#define def_HourMinuteSecond_DF                     @"HH:mm:ss"
#define def_HourMinute_DF                           @"HH:mm"

#define def_MonthDayWeekTwoChn_DF                   @"MM月dd日 EE"
#define def_MonthDayWeekChn_DF                      @"M月d日 EE"
#define def_WeekMonthDayChn_DF                      @"EE M月d日"

#define def_YearMonthDayHourMinute                  @"yyyy-M-d HH:mm"
#define def_Year1Month1Day                          @"yyyy-M-d"

#define def_YearMonth                               @"yyyy-MM"
#define def_year_month_day_hour                     @"Y年MM月d天H小时"
#define def_month_day_hour                          @"MM月d天H小时"
#define def_day_hour                                @"d天H小时"
#define def_hour                                    @"H小时"

@interface DateFormatter : NSObject
+ (NSString *) dateToStringCustom:(NSDate *)date formatString:(NSString *)formatString;
+ (NSDate *) stringToDateCustom:(NSString *)dateString formatString:(NSString *)formatString;
@end

@testable import day16
import XCTest

final class day16Tests: XCTestCase {
    func testPart1Sample() throws {
        let actual = day16.solvePart1(sampleInput)
        XCTAssertEqual(actual, 71)
    }

    func testPart1Real() throws {
        let actual = day16.solvePart1(realInput)
        XCTAssertEqual(actual, 19240)
    }

    func testPart2Real() throws {
        let actual = day16.solvePart2(realInput)
        XCTAssertEqual(actual, 21_095_351_239_483)
    }
}

// MARK: - Input

let sampleInput = """
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
"""

let realInput = """
departure location: 32-174 or 190-967
departure station: 50-580 or 588-960
departure platform: 35-595 or 621-972
departure track: 41-85 or 104-962
departure date: 39-293 or 299-964
departure time: 44-192 or 215-962
arrival location: 46-238 or 255-963
arrival station: 44-721 or 731-960
arrival platform: 29-826 or 846-958
arrival track: 49-525 or 543-953
class: 43-804 or 827-955
duration: 48-273 or 291-959
price: 45-767 or 793-967
route: 44-300 or 311-962
row: 25-119 or 140-954
seat: 38-389 or 410-974
train: 29-697 or 714-968
type: 32-55 or 65-968
wagon: 39-642 or 660-955
zone: 41-567 or 578-959

your ticket:
149,73,71,107,113,151,223,67,163,53,173,167,109,79,191,233,83,227,229,157

nearby tickets:
271,852,52,65,945,625,634,484,147,842,880,521,416,893,255,343,912,592,499,434
267,732,592,256,867,73,946,945,382,470,797,169,343,410,423,732,145,902,745,705
480,298,219,149,519,634,333,555,506,417,720,921,418,147,667,679,474,462,635,111
561,154,224,507,743,79,743,435,915,625,543,521,948,617,638,71,340,873,668,331
739,669,679,67,516,643,270,680,414,451,735,669,412,492,314,622,677,424,761,930
766,118,421,157,683,323,803,410,731,626,5,919,871,339,317,624,469,349,757,902
642,371,414,67,161,366,874,729,267,81,474,918,141,743,627,424,77,154,353,431
711,50,864,933,149,752,488,425,389,300,79,362,890,929,441,637,693,562,216,884
886,758,364,882,372,565,436,463,291,388,143,877,933,15,735,350,119,80,151,229
682,322,106,882,625,105,446,949,350,270,889,452,295,546,561,911,514,559,381,226
233,291,683,991,497,273,221,851,459,337,431,736,800,313,354,697,947,633,361,389
228,864,691,251,161,740,422,226,149,924,507,167,928,165,258,880,548,117,438,589
827,801,874,233,559,559,221,802,79,875,347,115,946,848,420,875,65,509,765,359
881,148,850,337,551,165,79,759,464,113,505,674,718,360,52,323,441,67,703,909
621,860,312,579,513,525,847,869,500,327,881,748,263,102,462,739,353,794,944,481
793,168,555,452,424,217,229,153,910,371,727,496,335,151,507,375,223,495,523,311
416,377,113,412,941,88,913,447,882,142,498,164,764,672,267,515,889,856,939,803
238,371,486,167,228,440,738,377,445,883,15,898,334,152,694,328,461,735,943,692
652,930,232,848,906,107,665,501,169,417,445,387,364,191,935,232,151,72,429,350
689,499,366,73,462,268,442,186,454,902,800,874,380,461,923,221,171,256,79,479
75,114,548,292,157,82,994,79,293,689,857,376,337,948,172,443,506,753,326,343
385,821,159,525,427,260,661,896,154,450,477,430,664,514,591,892,452,115,410,670
341,684,850,68,54,926,880,495,156,574,580,192,107,493,162,694,499,322,677,721
166,480,234,154,500,260,428,521,417,908,517,983,801,861,868,908,944,255,55,354
621,742,142,473,581,503,795,946,864,106,622,621,751,312,846,420,413,78,900,715
105,314,112,494,166,714,76,511,451,112,322,567,512,993,271,147,918,436,860,935
52,368,691,224,918,765,743,73,294,344,799,579,544,340,639,942,365,438,331,159
794,465,460,520,704,857,341,374,746,518,454,880,901,872,873,848,893,941,693,755
148,941,255,766,332,410,74,67,266,560,699,105,461,948,453,672,516,625,501,663
863,371,112,669,563,932,846,940,899,716,163,512,269,190,883,948,311,462,678,647
743,313,358,50,237,353,167,938,188,341,899,371,632,510,358,427,330,73,337,456
70,119,330,588,470,299,921,624,667,906,471,924,169,573,916,670,105,478,353,423
228,292,328,856,715,358,344,686,682,370,846,259,677,225,261,467,24,453,869,625
173,383,480,216,684,860,448,312,678,16,270,870,259,468,371,520,560,511,388,678
817,719,761,866,906,67,460,366,946,687,904,70,357,291,497,350,947,162,547,488
68,342,847,671,474,172,655,740,426,71,665,719,269,742,761,911,162,51,225,514
923,670,438,148,146,554,859,591,619,427,803,486,233,752,764,232,566,417,635,897
563,911,364,843,670,929,522,665,159,158,168,415,889,455,54,78,256,54,746,758
215,862,893,375,425,760,454,888,234,871,755,453,898,525,884,662,319,184,292,666
868,146,861,902,578,542,564,673,192,861,802,273,68,561,880,513,848,442,469,948
876,429,468,82,434,166,916,944,643,264,357,149,937,491,325,949,515,757,140,941
299,161,410,720,68,850,800,83,223,148,167,355,188,436,936,469,149,900,919,879
563,919,898,117,148,661,372,99,71,516,327,743,119,334,580,867,521,859,759,75
145,142,547,82,263,289,454,450,191,567,347,469,565,693,715,880,448,345,800,637
499,218,679,536,691,263,237,937,715,883,471,348,862,905,691,321,553,369,374,174
358,798,764,501,651,874,413,428,754,744,553,333,382,591,623,356,888,351,419,876
948,300,384,547,67,878,922,641,468,436,870,673,265,727,67,165,235,885,665,926
299,560,437,488,826,900,551,503,164,323,327,902,894,627,546,505,755,594,417,232
499,586,631,664,937,68,107,736,546,905,366,452,936,467,228,327,578,269,475,349
914,376,151,693,672,724,933,215,222,697,441,553,437,512,382,890,447,855,327,752
433,619,81,485,82,931,468,857,798,866,911,110,326,733,595,155,907,856,673,260
616,883,580,627,456,53,558,565,636,940,331,871,661,796,51,948,626,325,664,629
231,334,418,925,560,219,11,387,345,446,942,910,105,148,518,111,559,880,930,718
941,167,899,555,758,901,164,638,374,356,925,162,767,483,765,312,741,520,256,187
107,464,225,629,804,420,914,264,689,441,636,23,636,234,292,142,932,578,697,907
760,488,943,812,940,640,481,893,332,223,472,158,447,515,109,902,512,870,895,316
758,651,410,478,343,564,108,672,763,81,453,73,748,336,272,343,192,261,311,756
857,251,463,169,509,909,448,741,387,914,291,54,168,847,500,499,580,476,149,236
684,873,423,681,557,320,922,858,214,588,675,863,112,386,162,222,732,141,149,545
256,491,947,510,420,477,484,455,437,544,158,320,915,468,14,66,696,733,731,264
754,358,925,383,686,910,13,351,333,544,111,385,338,797,490,695,315,111,684,269
495,165,431,514,354,190,762,765,258,918,595,386,913,292,227,82,890,666,810,54
333,668,355,668,555,237,106,341,325,925,258,465,806,854,750,683,718,801,519,865
630,673,565,347,55,229,148,413,624,69,315,234,173,389,868,311,594,727,260,160
444,932,704,481,694,853,164,696,354,355,949,856,347,353,640,901,918,108,73,441
767,154,224,525,800,174,726,326,524,752,675,873,152,639,867,149,77,934,431,692
432,686,547,403,265,549,621,77,342,670,55,225,804,751,689,85,918,68,462,450
855,756,332,683,429,320,689,479,269,715,592,468,202,505,366,65,758,467,79,926
231,500,458,375,914,638,939,901,452,145,423,433,51,641,943,160,263,684,840,354
670,216,822,374,234,471,915,366,489,468,886,661,495,518,559,516,898,216,495,426
412,719,556,591,149,676,694,342,918,161,594,796,237,552,160,451,990,862,765,447
871,265,742,942,294,429,746,79,484,848,483,378,258,917,144,547,757,446,331,358
151,270,902,892,931,715,374,806,876,273,675,731,921,869,463,887,579,898,363,333
162,255,260,322,272,828,636,948,638,222,750,413,368,721,113,350,567,383,939,225
386,166,510,859,385,298,590,444,83,714,662,580,168,427,676,300,362,224,677,797
473,371,353,712,105,593,901,354,108,548,79,358,759,108,632,622,74,431,660,803
925,514,475,76,353,932,65,453,733,50,883,315,148,4,848,437,51,863,679,159
350,441,692,461,908,267,872,940,736,495,190,989,152,69,317,389,334,917,496,749
674,262,684,632,319,486,272,441,762,353,101,380,795,352,893,920,265,936,422,351
917,522,671,801,604,271,883,868,311,554,515,378,680,911,434,755,495,190,593,497
505,121,750,717,509,389,145,741,382,461,946,224,634,71,721,764,910,478,357,664
176,109,920,863,909,388,873,506,632,486,168,337,948,683,358,300,320,896,336,478
372,737,234,884,73,801,872,431,555,332,901,354,384,802,816,624,931,886,261,347
860,733,518,85,438,373,924,261,753,745,445,503,592,188,153,356,737,234,420,450
694,943,152,219,318,388,678,758,861,807,273,686,543,218,352,145,377,119,922,720
375,443,864,429,905,639,669,631,460,113,682,567,169,243,228,630,160,945,387,550
851,741,627,944,588,663,388,347,104,519,365,929,158,173,472,388,18,147,456,509
112,230,513,484,464,241,191,921,507,112,714,718,926,385,470,386,546,589,670,797
886,430,24,380,429,945,317,870,628,230,227,567,68,549,740,757,112,323,947,621
683,802,681,859,340,344,630,563,429,445,503,147,749,546,432,881,793,997,317,949
508,439,439,727,446,314,78,422,190,330,264,50,461,764,348,503,482,170,224,346
286,765,555,446,273,862,865,333,764,354,431,233,413,888,437,388,170,629,589,854
174,436,111,919,68,855,515,376,114,427,491,173,717,999,759,689,336,736,259,230
590,480,556,897,588,363,168,17,851,753,366,117,385,864,491,464,67,488,363,665
629,893,545,352,545,329,149,323,764,169,312,865,890,635,750,447,467,210,882,753
804,543,366,762,231,173,831,268,311,633,369,117,325,55,174,360,482,923,666,674
847,546,852,804,622,872,471,553,941,689,506,466,98,908,344,148,73,172,877,852
920,503,895,735,441,109,299,560,84,905,935,107,835,410,273,474,938,523,715,149
52,595,732,114,851,776,881,764,741,365,271,757,794,454,85,884,885,416,389,750
313,350,238,670,449,549,84,157,480,488,823,68,642,874,798,640,352,147,264,156
889,919,550,51,144,860,907,522,948,223,842,219,860,435,321,716,941,67,463,313
729,314,558,458,546,945,687,152,426,478,740,948,360,738,877,555,75,165,869,908
744,679,360,852,342,566,108,892,756,706,435,469,865,545,681,470,421,354,865,691
119,726,664,360,482,338,797,904,866,269,663,80,146,67,450,667,164,565,673,261
740,629,167,289,798,877,343,361,505,236,505,53,364,634,720,933,687,847,938,765
51,499,850,271,627,327,624,110,856,663,719,932,161,492,228,949,70,619,272,344
261,639,110,621,512,515,518,467,520,432,631,881,638,854,724,767,362,445,471,160
878,104,223,669,588,714,434,609,342,261,389,879,929,715,767,671,517,793,748,496
174,352,172,506,300,271,498,499,947,628,918,65,440,490,903,368,917,330,887,297
246,511,442,846,116,692,410,365,364,354,741,871,550,689,378,339,370,449,544,357
867,943,941,997,322,419,751,563,142,732,885,911,795,141,916,499,426,415,345,265
295,878,856,924,944,877,145,488,484,882,381,803,388,767,437,147,261,887,442,887
983,928,74,510,438,323,690,364,637,745,378,916,476,515,173,219,878,580,492,358
508,427,385,336,558,698,363,341,113,661,312,504,461,492,903,219,372,759,857,519
934,935,898,146,941,933,221,318,680,695,543,516,990,271,799,232,549,737,588,467
548,144,413,931,181,384,106,438,678,520,759,753,524,912,561,514,75,515,673,69
795,386,489,170,907,343,69,766,336,68,747,147,607,543,520,51,750,348,763,388
328,119,690,416,949,427,475,161,679,170,236,83,81,864,169,359,21,942,501,155
410,346,595,892,552,479,330,472,477,493,329,909,798,637,324,382,71,94,113,327
233,695,921,414,725,113,681,433,320,867,525,162,682,522,353,168,894,663,874,366
517,510,922,185,351,83,471,919,846,483,174,875,627,144,457,477,936,686,143,499
895,865,368,637,862,639,443,294,874,80,798,191,915,688,851,355,733,469,426,363
410,891,552,872,229,605,492,551,458,146,684,765,717,641,513,925,940,660,65,454
158,664,261,163,464,746,667,451,523,146,114,681,360,565,714,688,514,362,14,436
421,913,145,872,867,265,876,109,488,525,453,899,861,355,895,432,85,231,503,838
347,65,878,323,377,227,156,325,117,387,162,350,724,300,170,346,865,53,341,152
911,427,934,900,89,639,108,357,625,469,454,793,480,874,640,232,915,374,948,262
719,220,232,323,230,738,849,680,882,624,436,697,517,447,338,798,914,855,651,232
50,325,520,265,197,422,162,375,113,381,916,580,849,75,594,148,326,423,339,383
581,141,358,386,901,519,373,234,872,51,55,677,680,468,352,543,908,375,354,362
190,147,332,217,913,868,338,381,936,870,110,761,934,945,803,112,271,522,5,379
374,497,931,371,371,171,900,831,565,428,166,636,337,378,676,115,347,314,765,145
464,229,190,325,410,796,335,332,802,934,489,362,50,701,80,453,736,926,922,418
517,872,925,796,257,493,236,550,360,559,490,453,82,688,444,437,908,826,68,511
164,386,422,670,687,543,689,762,562,227,412,901,142,359,988,934,170,271,692,876
551,553,446,437,521,721,154,258,481,72,872,51,449,993,515,802,482,887,220,231
117,421,328,602,339,154,552,931,383,890,324,632,458,455,924,69,52,637,500,668
671,570,578,870,119,461,866,590,733,453,678,319,886,338,518,291,152,365,886,633
432,110,484,939,927,756,293,363,410,846,312,800,173,255,231,468,65,834,314,940
349,591,857,344,474,635,462,862,642,451,888,161,330,908,215,108,75,630,55,817
484,859,629,634,337,521,442,879,219,795,904,146,664,580,558,931,943,333,429,988
323,641,886,720,592,919,512,593,219,357,911,595,546,830,267,143,388,299,872,911
358,238,426,264,299,916,76,939,852,678,339,143,686,545,692,871,379,20,265,218
926,717,469,373,863,876,551,632,892,931,255,147,644,851,666,642,381,351,465,923
762,627,273,297,425,862,685,313,169,412,497,503,933,885,372,854,625,687,927,413
444,335,931,550,635,414,384,674,723,941,141,675,628,158,900,503,143,114,513,445
945,918,632,947,147,499,592,446,347,444,311,219,444,629,221,316,706,84,481,890
151,417,672,51,387,759,589,356,143,95,291,497,682,557,671,939,948,105,350,854
627,750,273,341,947,433,934,733,338,726,316,913,118,264,449,680,854,66,714,549
67,794,731,270,354,452,823,909,676,479,877,875,442,162,523,165,671,917,562,799
447,670,218,337,137,412,905,685,509,53,717,226,484,566,415,190,339,267,714,879
911,720,458,688,105,854,464,506,444,602,224,629,495,933,465,874,420,870,148,366
804,511,311,917,215,904,892,354,154,214,291,164,382,169,447,71,920,900,334,81
487,338,733,87,887,565,552,367,944,234,464,545,848,115,886,329,760,920,118,902
414,426,445,205,237,861,495,863,71,916,759,266,481,190,662,670,515,266,360,715
908,905,642,864,355,131,445,912,752,894,486,346,863,479,329,551,691,849,111,543
268,926,388,862,795,17,744,687,562,513,312,676,716,918,315,460,624,924,911,76
111,342,162,674,554,864,150,929,747,325,226,689,222,795,799,1,743,794,482,416
899,901,763,920,229,760,81,346,795,259,739,942,449,235,70,217,312,458,448,4
740,513,874,653,150,907,221,720,879,428,377,637,665,509,938,155,639,413,352,590
24,932,415,152,113,162,553,468,162,78,152,449,902,342,366,430,293,863,167,560
136,942,330,293,715,146,621,521,677,329,904,795,451,458,871,237,388,661,908,502
849,917,802,80,672,369,588,479,754,445,173,910,587,117,424,915,681,479,418,350
86,874,670,339,850,498,942,803,506,501,682,433,437,229,487,340,70,223,373,380
684,439,510,355,478,592,545,192,567,190,178,114,412,338,760,858,640,217,642,142
478,312,843,746,627,76,513,267,53,114,760,679,556,379,731,151,917,677,544,594
418,915,463,269,412,720,905,418,734,388,524,678,460,469,495,686,389,646,899,348
941,272,628,115,867,919,474,264,822,756,446,354,222,156,885,549,348,942,478,924
666,429,492,421,731,822,109,79,895,111,491,424,558,897,754,355,851,216,410,497
338,798,589,572,460,766,851,916,630,749,469,762,360,357,500,142,868,453,319,902
68,222,804,111,545,549,463,427,518,484,172,490,743,440,672,142,895,153,21,55
907,455,424,54,502,694,113,659,471,217,471,521,299,367,144,452,330,554,491,156
70,414,171,546,479,167,385,420,146,948,415,116,689,644,561,733,638,411,67,794
776,804,766,865,888,565,350,344,382,451,312,114,105,546,324,504,589,716,81,627
145,431,894,493,416,50,349,156,471,677,55,455,319,634,702,374,433,901,680,673
480,467,448,156,272,472,68,462,581,862,578,354,852,311,852,549,923,884,551,375
211,688,330,314,333,913,349,154,559,870,348,628,380,434,355,745,319,358,174,547
720,225,916,166,500,160,367,487,413,298,884,580,719,860,78,217,846,317,686,477
273,637,749,882,192,486,348,342,922,503,430,711,107,747,153,144,920,78,861,714
225,396,897,481,363,517,555,627,524,858,365,385,163,328,693,266,231,559,269,165
11,172,795,931,336,425,473,271,315,874,385,794,430,689,941,879,369,170,635,255
424,431,906,160,449,552,469,793,389,292,456,233,465,159,377,415,222,335,726,234
933,545,141,263,578,911,171,911,334,859,108,381,673,908,625,675,695,377,298,797
227,333,871,849,109,927,504,366,668,942,803,270,682,583,446,459,849,74,235,503
552,324,636,419,192,480,163,369,932,300,216,117,321,626,718,442,904,706,111,492
507,928,855,889,472,213,462,149,563,425,485,854,869,415,855,260,693,314,363,271
436,224,145,327,72,349,503,365,319,677,119,317,341,629,592,223,453,297,567,265
870,761,918,75,350,427,894,487,556,383,342,683,719,566,494,22,490,225,169,589
380,317,552,524,680,426,691,220,484,867,634,382,161,879,480,363,800,674,738,730
216,799,430,386,897,186,449,796,413,436,916,851,745,901,477,450,696,229,848,865
879,461,228,362,912,230,795,716,592,928,648,155,451,945,321,426,410,261,149,693
446,380,478,587,265,334,625,355,506,865,441,354,51,665,739,687,637,493,893,667
315,50,918,894,439,874,439,327,932,562,50,378,242,375,559,192,627,635,863,797
330,317,459,115,312,496,796,915,987,877,922,157,456,154,503,119,946,519,345,757
670,563,922,799,680,507,623,982,471,80,875,238,271,339,907,452,642,477,386,678
161,621,563,124,754,66,798,228,478,71,168,889,750,714,687,913,217,940,919,867
568,116,740,226,741,154,54,374,633,625,848,320,928,545,559,747,884,161,760,452
520,333,377,482,915,799,801,861,117,673,75,938,699,224,933,65,761,105,932,744
917,881,640,461,627,572,862,521,936,488,714,762,374,486,690,259,640,68,560,118
483,78,419,877,935,233,157,716,709,554,451,668,312,695,798,72,761,421,903,676
846,152,476,691,378,342,663,699,503,899,379,916,167,428,551,469,317,765,739,259
85,667,387,459,279,913,885,690,157,413,690,738,273,943,321,555,421,350,323,749
721,226,758,762,764,348,873,52,433,484,940,642,450,119,351,5,933,525,145,666
387,580,257,117,900,489,862,924,935,635,116,377,107,676,751,351,912,660,742,993
104,93,797,637,799,221,330,147,932,510,174,867,557,928,227,66,222,857,742,660
949,512,107,61,733,447,329,172,579,934,634,330,427,525,268,498,258,465,258,348
55,159,799,154,241,380,767,271,140,454,915,291,591,554,557,158,562,363,867,696
496,889,668,715,410,853,633,716,749,455,525,329,314,171,514,173,797,472,21,506
759,932,376,425,351,928,468,50,94,890,480,510,486,174,383,893,509,324,223,907
157,919,752,747,356,630,52,386,107,458,913,751,411,414,271,945,824,332,85,524
766,828,153,588,764,412,500,462,561,919,418,318,498,940,422,414,804,946,679,797
111,732,695,69,337,498,743,945,564,376,105,894,555,294,947,471,664,366,468,66
931,385,515,549,672,398,233,226,922,346,436,416,72,512,738,740,255,763,560,457
467,337,85,561,257,327,350,388,192,586,225,750,679,635,546,484,436,751,518,485
846,276,546,157,166,763,911,502,916,758,376,493,459,84,938,505,118,922,678,424
378,866,544,662,436,498,800,227,521,565,174,428,457,108,359,663,881,224,521,17
936,273,846,237,269,857,80,421,145,692,631,881,124,221,908,505,364,688,796,767
868,104,625,930,931,238,555,916,65,643,519,848,639,69,688,514,511,665,743,437
593,376,463,340,452,21,223,746,755,948,238,803,366,463,506,759,77,220,865,922
744,442,475,554,316,260,171,116,906,344,261,470,566,213,913,473,164,852,165,73
851,630,885,790,115,742,592,449,331,380,629,454,912,629,861,905,660,938,363,359
385,506,411,474,861,291,702,448,717,492,516,315,560,266,740,632,491,68,872,362
491,686,388,55,567,66,316,148,80,175,233,550,883,54,451,512,679,900,754,511
380,52,722,379,634,715,629,469,721,511,374,490,347,421,321,858,524,322,731,854
426,706,151,755,515,359,435,567,356,455,906,312,795,907,693,943,580,76,345,751
566,897,550,594,145,560,509,737,843,73,363,622,468,350,382,640,747,323,719,152
390,361,50,867,636,145,948,497,55,504,893,554,425,271,377,459,443,472,894,639
506,857,236,637,833,489,566,299,889,756,472,563,799,675,549,662,693,377,425,678
255,461,517,511,562,220,579,163,947,896,298,228,154,83,719,746,312,430,235,172
689,183,686,920,376,112,454,414,191,691,492,343,467,929,169,146,545,229,881,383
855,412,321,375,81,982,551,737,923,945,379,949,446,880,54,503,450,445,350,854
110,255,222,895,765,236,523,299,327,740,149,410,293,333,74,520,147,266,998,227
765,211,946,670,386,317,895,906,720,173,488,427,861,255,496,876,428,801,796,931
800,749,903,373,575,686,636,936,111,226,432,487,163,547,323,935,660,473,119,759
456,549,563,667,229,583,73,479,850,119,191,157,441,667,168,682,348,319,141,149
116,357,225,345,65,517,626,546,432,255,685,523,575,317,630,216,502,236,368,751
174,450,560,445,636,490,914,758,661,734,767,544,158,806,553,578,234,140,493,890
"""

Visualization_2015
========================================================
author: Ben, Mansun, Kyle
date: 2015.08


===
# Line Graph
## It's just that simple!

```r
# not meaningful but plottable
ggplot(pressure, aes(x=temperature, y=pressure)) + geom_line(size=1.5) 
```

<img src="Visualization_2015-figure/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="864" style="display: block; margin: auto;" />

Slide With Code
========================================================
<p style='text-align: center; font-size: 40pt;'>AND I am sick about IRIS, too.</p>
<br>
<br>
<div style='text-align: center;'>
    <img height='400' src='lecture_ggplot2/assets/img/determined-serious-chiseled-not-okay.png' />
</div>



========================================================
## A Digress: Function Equivalency in `ggplot2`
+ Mnay of the parameters can be applied in multiple ways
  + 
  + `ggtitle('yor title')` is the same as `labs(title='your title')`
  + See `?labs` for its equivalent calls
+ Many of the functions are siblings of a more general function
  + `geom_vline` is the sibling of `geom_abline`
  + `theme_bw` is a special version of `theme`
    + The default is `theme_grey`

===
## Let's try another sameple data

```r
head(WorldPhones)
str(WorldPhones)
```

```
     N.Amer Europe Asia S.Amer Oceania Africa Mid.Amer
1951  45939  21574 2876   1815    1646     89      555
1956  60423  29990 4708   2568    2366   1411      733
1957  64721  32510 5230   2695    2526   1546      773
1958  68484  35218 6662   2845    2691   1663      836
1959  71799  37598 6856   3000    2868   1769      911
1960  76036  40341 8220   3145    3054   1905     1008
 num [1:7, 1:7] 45939 60423 64721 68484 71799 ...
 - attr(*, "dimnames")=List of 2
  ..$ : chr [1:7] "1951" "1956" "1957" "1958" ...
  ..$ : chr [1:7] "N.Amer" "Europe" "Asia" "S.Amer" ...
```


===
## `ggplot`: data.frame only, please!

```r
ggplot(WorldPhones, aes(x=rownames(WorldPhones), y=Asia)) + geom_line()
## Error: ggplot2 doesn't know how to deal with data of class matrix
```
+ Remember: `ggplot` eat only data.frames

```r
WorldPhones.DF <- as.data.frame(WorldPhones)
WorldPhones.DF$year <- rownames(WorldPhones.DF)
class(WorldPhones.DF) # this time we should be fine!
```

```
[1] "data.frame"
```

===
## What the...?

```r
ggplot(WorldPhones.DF, aes(x=year, y=Asia)) + geom_line(size=1.5)
```

<img src="Visualization_2015-figure/unnamed-chunk-6-1.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" width="864" style="display: block; margin: auto;" />

===

## Or simply make x continous, if possible

```r
ggplot(WorldPhones.DF, aes(x=as.numeric(year), y=Asia)) + geom_line(size=1.5)
```

<img src="Visualization_2015-figure/unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="864" style="display: block; margin: auto;" />

Wait a minute...
===

Were they really drawn from the same data?

<img src="Visualization_2015-figure/unnamed-chunk-8-1.png" title="plot of chunk unnamed-chunk-8" alt="plot of chunk unnamed-chunk-8" width="468" style="display: block; margin: auto;" />

***


<br>
<br>

<img src="Visualization_2015-figure/unnamed-chunk-9-1.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="468" style="display: block; margin: auto;" />



Can you see the difference?
===
Remember? Categorical x at default will not show null data.

<img src="Visualization_2015-figure/unnamed-chunk-10-1.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" width="468" style="display: block; margin: auto;" />



***

<br>
<br>
<br>
<img src="Visualization_2015-figure/unnamed-chunk-11-1.png" title="plot of chunk unnamed-chunk-11" alt="plot of chunk unnamed-chunk-11" width="468" style="display: block; margin: auto;" />


===
## Multi-lining in `ggplot2`
+ Not straightforward, usually need preprocessing
  + Only accept **long** format, against the **wide** format used in `matplot`

Wide format

```
     N.Amer Europe Asia year
1951  45939  21574 2876 1951
1956  60423  29990 4708 1956
1957  64721  32510 5230 1957
1958  68484  35218 6662 1958
1959  71799  37598 6856 1959
1960  76036  40341 8220 1960
1961  79831  43173 9053 1961
```

===
## Multi-lining in `ggplot2`
Long format

```
   Value Region Year
1  45939 N.Amer 1951
2  60423 N.Amer 1956
3  64721 N.Amer 1957
4  68484 N.Amer 1958
5  71799 N.Amer 1959
6  76036 N.Amer 1960
7  79831 N.Amer 1961
8  21574 Europe 1951
9  29990 Europe 1956
10 32510 Europe 1957
```

====

## Wide-to-long Conversion

```r
WP <- WorldPhones.DF[, c(1:3, 8)]
head(WP,3)
```

```
     N.Amer Europe Asia year
1951  45939  21574 2876 1951
1956  60423  29990 4708 1956
1957  64721  32510 5230 1957
```

```r
WP.long <- melt(WP,id.vars = 'year')
colnames(WP.long) <- c('Year', 'Region', 'Value')
head(WP.long)
```

```
  Year Region Value
1 1951 N.Amer 45939
2 1956 N.Amer 60423
3 1957 N.Amer 64721
4 1958 N.Amer 68484
5 1959 N.Amer 71799
6 1960 N.Amer 76036
```

===

## The rest is easy!



```r
WP.long$Year <- as.integer(as.character(WP.long$Year))
ggplot(WP.long, aes(x=Year, y=Value, color=Region)) + geom_line(size=1.5)
```

<img src="Visualization_2015-figure/unnamed-chunk-15-1.png" title="plot of chunk unnamed-chunk-15" alt="plot of chunk unnamed-chunk-15" width="864" style="display: block; margin: auto;" />

===

## More grouping var: linetype

```r
ggplot(WP.long, aes(x=Year, y=Value, linetype=Region)) + geom_line(size=1.5)
```

<img src="Visualization_2015-figure/unnamed-chunk-16-1.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" width="864" style="display: block; margin: auto;" />

===

## Again, beware of categorical x!

```r
ggplot(WP.long, aes(x=factor(Year), y=Value, linetype=Region, group=Region)) + geom_line(size=1.5)
```

<img src="Visualization_2015-figure/unnamed-chunk-17-1.png" title="plot of chunk unnamed-chunk-17" alt="plot of chunk unnamed-chunk-17" width="864" style="display: block; margin: auto;" />

===
## Reverse order of legend labels

```r
ggplot(WP.long, aes(x=Year, y=Value, linetype=Region)) + geom_line(size=1.5) +
  guides(linetype=guide_legend(reverse=TRUE))
```

<img src="Visualization_2015-figure/unnamed-chunk-18-1.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="864" style="display: block; margin: auto;" />

===

## Exercise: Humidity!

<img src="Visualization_2015-figure/unnamed-chunk-19-1.png" title="plot of chunk unnamed-chunk-19" alt="plot of chunk unnamed-chunk-19" width="864" style="display: block; margin: auto;" />


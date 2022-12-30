<h1 style="font-weight:normal">
  Radial Heatmap Generator :radio_button:
</h1>

[![Status](https://img.shields.io/badge/status-active-success.svg)]() [![GitHub Issues](https://img.shields.io/github/issues/wjsutton/tableau_public_api.svg)](https://github.com/wjsutton/tableau_public_api/issues) [![GitHub Pull Requests](https://img.shields.io/github/issues-pr/wjsutton/tableau_public_api.svg)](https://github.com/wjsutton/tableau_public_api/pulls) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

An R Shiny app that builds a radial heatmap template to use in Tableau.

[Twitter][Twitter] :speech_balloon:&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[LinkedIn][LinkedIn] :necktie:&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[GitHub :octocat:][GitHub]&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[Website][Website] :link:

<!--
Quick Link 
-->

[Twitter]:https://twitter.com/WJSutton12
[LinkedIn]:https://www.linkedin.com/in/will-sutton-14711627/
[GitHub]:https://github.com/wjsutton
[Website]:https://wjsutton.github.io/

## :a: About

Radial heatmaps looks great and can be effective for visual metaphors of representing data by time e.g. 24 hours in a day, 12 months in a year. 

However, there are some drawbacks:

- Radial data is hard to intepret than data plotted on a straight line
- Inner rings occupy less space than outer ones, so can be viewed as less important
- Plotting a circle on a square area leaves unused space in the corners (but you can add notes and insights here)

## :hammer: The Shiny App

To help creating Radial Heatmap in Tableau I've built an app using R and Shiny to generate the coordinates. 

You can find the app here: [wjsutton.shinyapps.io/radial_heatmap](https://wjsutton.shinyapps.io/radial_heatmap/)

<a href='https://wjsutton.shinyapps.io/radial_heatmap/'>
  <img src='https://github.com/wjsutton/radial_heatmap_generator/blob/main/shiny_app_screenshot.png?raw=true' width='100%' >
</a>

Using this app you can build a template for a radial heatmap by changing the parameters, and download the data to a csv file. 

## :heavy_plus_sign: Adding to Tableau

To create the radial heatmap in Tableau you'll need to join the template to your data source. The join should be either by:

- Segments and Rings
- Individual blocks

Numbering:

- Segments are numbered from 1, with the first being the top (north) segment and counted clockwise
- Rings are numbered from 1, with the first being the inner most ring and counted from inner to outer
- Blocks are numbered from 1, with the first being top block inner most ring, and counted clockwise around the ring, then on to the next from from inner to outer.

### Demo

In the Tableau dashboard: [Radial Heatmap Template](https://public.tableau.com/app/profile/wjsutton/viz/RadialHeatmapTemplateB2VBWeek202022/RadialHeatmapTemplate)
 
I've taken the data from Back 2 Viz Basic's [Week 20 2022 Change Over Time](https://data.world/back2vizbasics/2022week-20-change-over-time) challenge to demo build the template. 

It's a simple dataset of 3 columns:

| Month | Survey Year | Percent |
|:----|:---------|:---------|
| January | 1960 | 2 |
| February | 1960 | 1 |
| March | 1960 | 2 |

### Joining the Datasets

To join this data to the template I'll show:

#### Survey Years = Rings

- Using a CASE statement to convert the years to 1, 2, 3. e.g. `CASE [Survey Year] WHEN 1960 THEN 1 WHEN 2005 THEN 2 WHEN 2021 THEN 3 END`

#### Months = Segments

- Using `DATEPART('month' [Month])` to number months from 1-12, note: Month must be as a date data type 

### Building the Radial in Tableau

Construct the radial from template

- Add X to Rows
- Add Y to Columns
- Add Block Id to Detail in the Marks Card (right click convert to dimension)
- Add Segment to Detail in the Marks Card (right click convert to dimension)
- Add Ring to Detail in the Marks Card (right click convert to dimension)
- Convert Mark Type to Polygon
= Add Path to Path in the Marks Card (right click convert to dimension)

Incorporate the data (Back 2 Viz Basic's [Week 20 2022 Change Over Time](https://data.world/back2vizbasics/2022week-20-change-over-time))

- Add percent onto Color Mark
- Add Month to Detail in the Marks Card (right click convert to date format as Month and data type as Discrete)
- Add Survey Year to Detail in the Marks Card (right click convert to dimension)

You can check your work against the template Tableau dashboard: [Radial Heatmap Template](https://public.tableau.com/app/profile/wjsutton/viz/RadialHeatmapTemplateB2VBWeek202022/RadialHeatmapTemplate)


## :page_with_curl: The Source Code

The code works from two functions:

- **build_block** which creates the coordinates for individual blocks in a radial heatmap
- **build_radial_map** which creates generates all the blocks for a radial heatmap

You can review the functions and more notes in the test script: [create_radial_heatmap.R](https://github.com/wjsutton/radial_heatmap_generator/blob/main/create_radial_heatmap.R)


Will Sutton, December 2022<br>
[Twitter][Twitter] :speech_balloon:&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[LinkedIn][LinkedIn] :necktie:&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[GitHub :octocat:][GitHub]&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[Website][Website] :link:

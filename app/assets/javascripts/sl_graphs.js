
/*
.map(function(series) {
  series.values = series.values.map(function(d) {
    return { x: d[0], y: d[1] }
  });
  return series;
});
*/

//an example of harmonizing colors between visualizations
//observe that Consumer Discretionary and Consumer Staples have 
//been flipped in the second chart
var colors = d3.scale.category20();
keyColor = function(d, i) {return colors(d.key)};

nv.addGraph(function() {
  var chart = nv.models.multiBarChart()
                .x(function(d) { return d[0] })
                .y(function(d) { return d[1] })
                .color(keyColor)
                .clipEdge(true);

  chart.xAxis
      .tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) });
      
  chart.yAxis
      .tickFormat(d3.format(',.2f'));

  d3.select('#user_chart svg')
    .datum(user_logs)
      .transition().duration(500).call(chart);

  nv.utils.windowResize(chart.update);

  return chart;
});
nv.addGraph(function() {
  var chart = nv.models.multiBarChart()
                .x(function(d) { return d[0] })
                .y(function(d) { return d[1] })
                .color(keyColor)
                //.clipEdge(true);

  chart.xAxis
      .tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) });
      
  chart.yAxis
      .tickFormat(d3.format(',.f'));

  

  d3.select('#project_chart svg')
    .datum(project_logs)
      .transition().duration(500).call(chart);

  nv.utils.windowResize(chart.update);

  return chart;
});










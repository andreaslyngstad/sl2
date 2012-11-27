



$(document).ready(function() {
var userColorArray = [	"#393b79", 
					"#5254a3", 
					"#6b6ecf", 
					"#9c9ede", 
					"#7b4173", 
					"#a55194", 
					"#ce6dbd", 
					"#de9ed6",
					"#843c39", 
					"#ad494a", 
					"#d6616b", 
					"#e7969c", 
					"#637939", 
					"#8ca252", 
					"#b5cf6b", 
					"#cedb9c", 
					"#8c6d31", 
					"#bd9e39", 
					"#e7ba52", 
					"#e7cb94" ];
var projectColorArray = ["#31a354", "#74c476", "#a1d99b","#2ca02c", "#98df8a","#ADFF2F",
                "#00FF00",
                "#32CD32",
                "#98FB98",
                "#90EE90",
                "#00FA9A",
                "#00FF7F",
                "#3CB371",
               "#2E8B57",
                "#228B22",
                "#008000",
                "#006400",
                 "#9ACD32",
                "#6B8E23",
                "#808000",
                "#556B2F",
                "#66CDAA",
                "#8FBC8F",
                 "#20B2AA",
                 "#008B8B",
                 "#008080"];
var products_stacked, products_pie, user_stacked, user_pie, projects_bar
 


$.getJSON('users_logs_chart.json', function(data) {
  nv.addGraph(function() {
    var chart = nv.models.legendChart()    
    d3.select('#legend svg')
    .datum(data)
     });
     
     
     
  nv.addGraph(function() {
    var chart = nv.models.stackedAreaChart()
   				.margin({top: 10, bottom: 30, left: 40, right: 10})
                  .showControls(false)
                  .showLegend(true)
                  .style('stacked')
                  .x(function(d) { return d[0] })
                  .y(function(d) { return d[1] })
                  .color(userColorArray)
                  .clipEdge(true)
                  .interpolate("cardinal");

    chart.xAxis
        .showMaxMin(false)
        .tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) });
        
    chart.yAxis
        .tickFormat(d3.format(',.2f'));
  	
    d3.select('#user_bar svg')
      .datum(data)
      .transition().duration(5000).call(chart);
      nv.utils.windowResize(chart.update);
      chart.legend.dispatch.on('legendClick.there', function(e){
  setTimeout(function() {
    console.log(user_pie)
        user_pie.update();
      }, 100);
});
   users_stacked = chart
    return chart;
  });
});

nv.addGraph(function() {
  var chart = nv.models.stackedAreaChart()
 				.margin({top: 10, bottom: 30, left: 40, right: 10})
                .showControls(false)
                .showLegend(true)
                .style('stacked')
                .x(function(d) { return d[0] })
                .y(function(d) { return d[1] })
                .color(projectColorArray)
                .clipEdge(true)
                
                .interpolate("cardinal");
  chart.xAxis
    .showMaxMin(false)
    .tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) });
  
  chart.yAxis
    .tickFormat(d3.format(',.2f'));
  
  d3.select('#project_stacked svg')
    .datum(project_logs)
    .transition().duration(500).call(chart);
  
  nv.utils.windowResize(chart.update);
  
 chart.legend.dispatch.on('legendClick.updateExamples', function() {
      setTimeout(function() {
     	
        products_pie.update();
      }, 100);
    });
  products_stacked = chart
  return chart;
});
nv.addGraph(function() {
  var chart = nv.models.pieChart()
      .x(function(d) { return d.label })
      .y(function(d) { return d.value })
      .showLegend(true)
      .margin({top: 10, bottom: 30, left: 40, right: 10})
      .color(userColorArray)
      .showLabels(false);

    d3.select("#user_pie svg")
        .datum(user_logs_pie)
      .transition().duration(500)
        .call(chart);
        nv.utils.windowResize(chart.update);
     chart.legend.dispatch.on('legendClick.there', function(e){
  setTimeout(function() {
        users_stacked.update();
      }, 100);
});
	user_pie = chart
  return chart;
});
nv.addGraph(function() {
  var chart = nv.models.pieChart()
      .x(function(d) { return d.label })
      .y(function(d) { return d.value })
      .showLegend(true)
      .margin({top: 10, bottom: 30, left: 40, right: 10})
      .color(userColorArray)
      .showLabels(false);

    d3.select("#legend svg")
        .datum(user_logs_pie)
      .transition().duration(500)
        .call(chart);
        
     
  user_pie = chart
  return chart;
});



nv.addGraph(function() {
  var chart = nv.models.pieChart()
      .x(function(d) { return d.label })
      .y(function(d) { return d.value })
      .color(projectColorArray)
      .margin({top: 10, bottom: 30, left: 40, right: 10})
      .showLabels(false);

    d3.select("#project_pie svg")
        .datum(project_logs_pie)
      	.transition().duration(500)
        .call(chart);
	products_pie = chart
  return chart;
});
nv.addGraph(function() {
  var chart = nv.models.multiBarChart()
 				.margin({top: 10, bottom: 30, left: 40, right: 10})
                .showControls(true)
                .showLegend(true)
                
                .x(function(d) { return d[0] })
                .y(function(d) { return d[1] })
                .color(projectColorArray)
                .clipEdge(true);
  chart.xAxis
    .tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) });
  
  chart.yAxis
    .tickFormat(d3.format(',.2f'));
  
  d3.select('#project_bar svg')
    .datum(project_logs)
    .transition().duration(500).call(chart);
  
  nv.utils.windowResize(chart.update);
  
 chart.legend.dispatch.on('legendClick.update', function() {
      setTimeout(function() {
     	console.log("products_stacked")
        products_stacked.update();
      }, 100);
    });
  products_stacked = chart
  return chart;
  });
})




function stackedAndPie(data, ColorArray) {
  	var labels = data.stacked.map(function(d){return d.key});
	var pieIdIncrement = labels.length;
	nv.addGraph(function() {
	    var chart = nv.models.stackedAreaChart()
	   				.margin({top: 10, bottom: 30, left: 40, right: 10})
	                  .showControls(false)
	                  .showLegend(true)
	                  .style('stacked')
	                  .x(function(d) { return d[0] })
	                  .y(function(d) { return d[1] })
	                  .color(ColorArray)
	                  .clipEdge(true)
	                  .interpolate("cardinal");
	    chart.xAxis
	        .showMaxMin(false)
	        .tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) });
	        
	    chart.yAxis
	        .tickFormat(d3.format(',.2f'));
	  	
	    d3.select('#stacked svg')
	        .datum(data.stacked)
	        .transition().duration(500).call(chart);
	    d3.selectAll(".nv-series").each(function(d,i) { 
	    d3.select(this).attr("id", function() { return 'nv-series-' + i }) 
	      }); 
	   stacked = chart
	   return chart; 
	});
  
	  nv.addGraph(function() {
	  var chart = nv.models.pieChart()
	      .x(function(d) { return d.label })
	      .y(function(d) { return d.value })
	      .showLegend(true)
	      .margin({top: 10, bottom: 30, left: 40, right: 10})
	      .color(ColorArray)
	      .showLabels(false);
	
	    d3.select("#pie svg")
	      .datum(data.pie)
	      .transition().duration(500).call(chart);
	    d3.selectAll(".nv-area").each(function(d,i) { 
	    d3.select(this).attr("id", function() { return i })
	      });
	    d3.selectAll(".nv-series").each(function(d,i) { 
	    d3.select(this).attr("id", function() { return 'nv-series-' + i })
	      
	      });
	    d3.selectAll(".nv-legendWrap").style("display","none")
	  pie = chart
	  
	  return chart;
	});

	function disableSetter(area, id, graph, label){
	  var dot = $("#" + id +".node .legend_dot")
	  d3.select("#nv-series-" + id).attr("data", function(d){
	    if(!(d3.select(area).selectAll(".nv-series").data().filter(function(e) { return !e.disabled }).length === 1))
	    {
	      d.disabled = !d.disabled;
	      dot.toggleClass("disabled")
	    }else
	    {
	      d.disabled = false;
	      dot.removeClass("disabled")
	    }
	    graph.update()
	    })
	};
	var div = d3.select("#legend").append("div").attr("class", "labels");
	var li = div.selectAll("li")
	   .data(labels)
	   .enter()
	   .append("li")
	       .attr('id', function(d, i) { return   i  }) 
	       .attr('class', 'node');
	       
	       
	       
	var lidiv = li.append("div")
	         .attr('class', 'legend_dot')
	       
	lidiv.append("svg")
	        .attr("width", "20px")
	        .attr("height", "20px")
	    .append("circle")
	        .attr("r", 8)
	        .attr("cx", 10)
	        .attr("cy", 10)
	        .style('stroke-width', 2)
	        .style('fill', (function(d, i){ return ColorArray[i] }))
	        .style('stroke', (function(d, i){ return ColorArray[i] }));
	li.append("div")
	    .attr('class', 'legend_text')  
	    .text(function(d) { return   d  });
	
	d3.selectAll(".labels .node").on("click", function(d) {
	    var id = $(this).attr("id");
	    var pieId = parseInt(id) + parseInt(pieIdIncrement)
	    
	     disableSetter("#stacked svg", id, stacked)
	     disableSetter("#pie svg", pieId, pie)   
	 });
}


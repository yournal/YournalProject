d3fun = (['$window','$timeout','d3Service',($window, $timeout, d3Service) ->
  return {
    restrict: 'EA
    scope: {}'
    link: (scope, element, attrs) ->
      d3Service.d3().then (d3) ->
        # d3 is the raw d3 object

        margin = parseInt(attrs.margin) || 20
        barHeight = parseInt(attrs.barHeight) || 20
        barPadding = parseInt(attrs.barPadding) || 5
        #renderTimeout

        svg = d3.select(element[0])
          .append("svg")
          .style('width', '100%')

        # Browser onresize event
        window.onresize = () ->
          scope.$apply()

        # hard-code data
        scope.data = [
          {name: "Greg", score: 98},
          {name: "Ari", score: 96},
          {name: 'Q', score: 75},
          {name: "Loser", score: 48}
        ]

        # Watch for resize event
        scope.$watch( () ->
          angular.element($window)[0].innerWidth
        , () ->
          scope.render(scope.data)
        )

        scope.render = (data) ->
          # our custom d3 code
          svg.selectAll('*').remove()
   
          #if !data return
          #if(renderTimeout) clearTimeout(renderTimeout)
   
          renderTimeout = $timeout( () ->
            width = d3.select(element[0])[0][0].offsetWidth - margin
            height = scope.data.length * (barHeight + barPadding)
            color = d3.scale.category20()
            xScale = d3.scale.linear()
              .domain( [0, d3.max(data, (d) -> d.score)] )
              .range([0, width])
   
            svg.attr('height', height)
           
            svg.selectAll('rect')
              .data(data)
              .enter()
              .append('rect')
              .on('click', (d,i) ->
                scope.onClick({item: d})
              )
              .attr('height', barHeight)
              .attr('width', 140)
              .attr('x', Math.round(margin/2))
              .attr('y', (d,i) ->
                i * (barHeight + barPadding)
              )
              .attr('fill', (d) ->
                return color(d.score)
              )
              .transition()
              .duration(1000)
              .attr('width', (d) ->
                xScale(d.score)
              )

            svg.selectAll('text')
              .data(data)
              .enter()
              .append('text')
              .attr('fill', '#fff')
              .attr('y', (d,i) ->
                i * (barHeight + barPadding) + 15
              )
              .attr('x', 15)
              .text( (d) ->
                d.name + " (scored: " + d.score + ")"
              )
          , 200)
  }
])

app = angular.module 'yournal.directives'
app.directive 'd3Bars', d3fun




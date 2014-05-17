getFisheye = (d3) ->
  # i don't know wtf i'm doing
  d3.fisheye = {
    scale: (scaleType) ->
      d3_fisheye_scale(scaleType(), 3, 0)
    circular: () ->
      radius = 200
      distortion = 2
      k0 = 0
      k1 = 0
      focus = [0, 0]

      fisheye = (d) ->
        dx = d.x - focus[0]
        dy = d.y - focus[1]
        dd = Math.sqrt(dx * dx + dy * dy)
        if !dd or dd >= radius
          return {x: d.x, y: d.y, z: 1}
        k = k0 * (1 - Math.exp(-dd * k1)) / dd * .75 + .25
        return {x: focus[0] + dx * k, y: focus[1] + dy * k, z: Math.min(k, 10)}

      rescale = () ->
        k0 = Math.exp(distortion)
        k0 = k0 / (k0 - 1) * radius
        k1 = distortion / radius
        return fisheye

      fisheye.radius = (_) ->
        if !arguments.length
          return radius
        radius = +_
        return rescale()

      fisheye.distortion = (_) ->
        if !arguments.length
          return distortion
        distortion = +_
        return rescale()

      fisheye.focus = (_) ->
        if !arguments.length
          return focus
        focus = _
        return fisheye

      return rescale()
  }

  d3_fisheye_scale = (scale, d, a) ->
    fisheye = (_) ->
      x = scale(_)
      left = x < a
      v = 0
      range = d3.extent(scale.range())
      min = range[0]
      max = range[1]
      m = left ? a - min : max - a
      if m == 0
        m = max - min
      return (left ? -1 : 1) * m * (d + 1) / (d + (m / Math.abs(x - a))) + a

    fisheye.distortion = (_) ->
      if !arguments.length
        return d
      d = +_
      return fisheye

    fisheye.focus = (_) ->
      if !arguments.length
        return a
      a = +_
      return fisheye

    fisheye.copy = () ->
      return d3_fisheye_scale(scale.copy(), d, a)

    fisheye.nice = scale.nice
    fisheye.ticks = scale.ticks
    fisheye.tickFormat = scale.tickFormat
    return d3.rebind(fisheye, scale, "domain", "range")

  return d3

d3fun = (['$window','$timeout','d3Service',($window, $timeout, d3Service) ->
  return {
    restrict: 'EA'
    scope: { data: '=' }
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
        #scope.data = [
        #  {name: "Greg", score: 98},
        #  {name: "Ari", score: 96},
        #  {name: 'Q', score: 75},
        #  {name: "Loser", score: 48}
        #]

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

d3fish = (['$window','$timeout','d3Service',($window, $timeout, d3Service) ->
  return {
    restrict: 'EA'
    scope: { data: '=' }
    link: (scope, element, attrs) ->
      d3Service.d3().then (d3) ->
        # d3 is the raw d3 object
        d3 = getFisheye(d3)

        width = 960
        height = 500

        color = d3.scale.category20()
        fisheye = d3.fisheye.circular()
          .radius(120)

        force = d3.layout.force()
          .charge(-240)
          .linkDistance(40)
          .size([width, height])

        svg = d3.select(element[0]).append("svg")
          .attr("width", width)
          .attr("height", height)

        svg.append("rect")
          .attr("class", "background")
          .attr("width", width)
          .attr("height", height)

        d3.json("json/miserables.json", (data) ->
          n = data.nodes.length
          force.nodes(data.nodes).links(data.links)

          # Initialize the positions deterministically, for better results.
          data.nodes.forEach( (d, i) ->
            d.x = d.y = width / n * i
          )

          # Run the layout a fixed number of times.
          # The ideal number of times scales with graph complexity.
          # Of course, don't run too long—you'll hang the page!
          force.start()
          for i in [0..n]
            force.tick()
          force.stop()

          # Center the nodes in the middle.
          ox = 0
          oy = 0
          data.nodes.forEach( (d) ->
            ox += d.x
            oy += d.y
          )

          ox = ox / n - width / 2
          oy = oy / n - height / 2
          data.nodes.forEach( (d) ->
            d.x -= ox
            d.y -= oy
          )

          link = svg.selectAll(".link")
            .data(data.links)
            .enter().append("line")
            .attr("class", "link")
            .attr("x1", (d) -> d.source.x )
            .attr("y1", (d) -> d.source.y )
            .attr("x2", (d) -> d.target.x )
            .attr("y2", (d) -> d.target.y )
            .style("stroke-width", (d) -> Math.sqrt(d.value) )

          node = svg.selectAll(".node")
            .data(data.nodes)
            .enter().append("circle")
            .attr("class", "node")
            .attr("cx", (d) -> d.x )
            .attr("cy", (d) -> d.y )
            .attr("r", 4.5 )
            .style("fill", (d) -> color(d.group) )
            .call(force.drag)

          svg.on("mousemove", () ->
            fisheye.focus(d3.mouse(this))

            node.each( (d) -> d.fisheye = fisheye(d) )
              .attr("cx", (d) -> d.fisheye.x )
              .attr("cy", (d) -> d.fisheye.y )
              .attr("r", (d) -> d.fisheye.z * 4.5 )

            link.attr("x1", (d) -> d.source.fisheye.x )
              .attr("y1", (d) -> d.source.fisheye.y )
              .attr("x2", (d) -> d.target.fisheye.x )
              .attr("y2", (d) -> d.target.fisheye.y )
          )
        )
  }
])

app = angular.module 'yournal.directives'
app.directive 'd3Bars', d3fish




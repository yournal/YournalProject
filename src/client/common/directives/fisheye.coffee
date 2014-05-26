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
    return d3.rebind(fisheye, scale, 'domain', 'range')

  return d3

module = mean.module 'yournal.directives.fisheye'
module.directive 'fisheye', ([
  '$window',
  '$timeout',
  '$state'
  ($window, $timeout, $state) ->
    restrict: 'EA'
    scope:
      data: '='
    link: (scope, element, attrs) ->
      scope.$watch 'data', (data) ->
        if not data?
          return
        # d3 is the raw d3 object
        d3 = getFisheye($window.d3)

        width = d3.select(element[0])[0][0].offsetWidth
        height = 400
        nodeRadius = 7.5

        color = d3.scale.category20()
        fisheye = d3.fisheye.circular()
          .radius(120)

        force = d3.layout.force()
          .charge(-240)
          .linkDistance(40)
          .size([width, height])

        svg = d3.select(element[0]).append('svg')
          .attr('width', '100%')
          .attr('height', '400')

        svg.append('rect')
          .attr('class', 'rect-background')
          .attr('width', '100%')
          .attr('height', '400')

        data = null

        angular.element($window).bind 'resize', ->
          width = d3.select(element[0])[0][0].offsetWidth
          force = d3.layout.force()
            .charge(-240)
            .linkDistance(40)
            .size([width, height])
          if data?
            d3.selectAll(".node").remove()
            d3.selectAll(".link").remove()
            d3.selectAll(".d3tooltip").remove()
            scope.render(data)

        scope.$watch('data', (newData) ->
          data = newData
          scope.render(data)
        )

        scope.render = (data) ->


          if not data?
            return

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
          if n > 100
            nn = n
          else
            nn = 100
          for i in [0..nn]
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

          link = svg.selectAll('.link')
            .data(data.links)
            .enter().append('line')
            .attr('class', 'link')
            .attr('x1', (d) -> d.source.x )
            .attr('y1', (d) -> d.source.y )
            .attr('x2', (d) -> d.target.x )
            .attr('y2', (d) -> d.target.y )
            .style('stroke-width', (d) -> Math.sqrt(d.value) )

          node = svg.selectAll('.node')
            .data(data.nodes)
            .enter().append('circle')
            .attr('class', 'node')
            .attr('cx', (d) -> d.x )
            .attr('cy', (d) -> d.y )
            .attr('data-name', (d) -> d.name )
            .attr('data-_id', (d) -> d._id )
            .attr('data-year', (d) -> d.year )
            .attr('data-volume', (d) -> d.volume )
            .attr('data-issue', (d) -> d.issue )
            .attr('data-section', (d) -> d.section )
            .attr('r', nodeRadius )
            .style('fill', (d) -> color(d.group) )
            .call(force.drag)



          tooltip = d3.select('.wrapper')
            .append('div')
            .attr('class', 'd3tooltip')
            .style('position', 'absolute')
            .style('z-index', '10')
            .style('visibility', 'hidden')

          svg.on('mousemove', () ->
            fisheye.focus(d3.mouse(this))

            node.each( (d) -> d.fisheye = fisheye(d) )
              .attr('cx', (d) -> d.fisheye.x )
              .attr('cy', (d) -> d.fisheye.y )
              .attr('r', (d) -> d.fisheye.z * nodeRadius )

            link.attr('x1', (d) -> d.source.fisheye.x )
              .attr('y1', (d) -> d.source.fisheye.y )
              .attr('x2', (d) -> d.target.fisheye.x )
              .attr('y2', (d) -> d.target.fisheye.y )
          )

          node.on('mouseover', () ->
            tooltip.style('visibility', 'visible')
              .text(this.getAttribute 'data-name')
          ).on('mousemove', () ->
            tooltip.style('top', (d3.event.pageY-10)+'px')
              .style('left',(d3.event.pageX+10)+'px')
          ).on('mouseout', () ->
            tooltip.style('visibility', 'hidden')
          ).on('click', () ->
            id = this.getAttribute 'data-_id'
            if id?
              year = this.getAttribute 'data-year'
              volume = this.getAttribute 'data-volume'
              issue = this.getAttribute 'data-issue'
              section = this.getAttribute 'data-section'
              $state.go('article', {year: year, volume: volume, number: issue, section: section, article: id}) if id?
          )
])

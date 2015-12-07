module.directive "chart", ($parse) ->

  restrict: "E"
  replace: false

  scope:
    data  : "=chartData"
    width : "=width"
    height: "=height"

  link: (scope, element, attrs) ->

    chart = d3.select(element[0]).append("svg")

    draw = ->
      chart.attr("height", scope.height).attr "width", scope.width
      bars = chart.selectAll("rect")
        .data(angular.fromJson(scope.data))
        .attr("width", (d, i) -> d * 20)
        .attr("height", 10)
        .attr("x", 5)
        .attr("y", (d, i) -> i * 20)
        .attr("fill", "steelblue")
      bars.enter().append("rect")
        .attr("width", (d, i) -> d * 20)
        .attr("height", 10)
        .attr("x", 5)
        .attr("y", (d, i) -> i * 20)
        .attr "fill", "steelblue"
      bars.exit().remove()

      return

    scope.$watch "data", (newVal, oldVal) ->

      try
        JSON.parse newVal
        draw()
      return

    return

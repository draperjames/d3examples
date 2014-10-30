# the main function that makes all of the plots
plot = (data) ->
    n_states = data.state.length

    # sizes of things
    htop = 500
    hbot = 500
    height = htop + hbot

    margin_top = {left:5, top:40, right:25, bottom:40, inner:0}
    fullpanelwidth_top = 180
    panelwidth_top = fullpanelwidth_top - margin_top.left - margin_top.right
    panelheight_top = htop - margin_top.top - margin_top.bottom
    statenamewidth = 201
    width = statenamewidth + fullpanelwidth_top*6

    margin_bot = {left:60, top:40, right:40, bottom:40, inner:5}

    panelwidth_bot = width/3

    # print the sizes of things
    console.log("width = #{width}")
    console.log("height = #{height}")
    console.log("top width = #{panelwidth_top}")
    console.log("bot width = #{panelwidth_bot}")

    # make the svg
    svg = d3.select("div#chart")
            .append("svg")
            .attr("height", height)
            .attr("width", width)

    top_panel_var = ["total", "not_distracted", "speeding", "alcohol", "ins_premium", "ins_losses"]
    xlim = [[0,25],[0,25],[0,25],[0,25],[0,1500],[0,200]]
    nxticks = [6,6,6,6, 4, 5]
    xlab = ["", "", "", "", "Dollars", "Dollars"]
    title = ["Total", "Not distracted", "Speeding", "Alcohol", "Ave. Ins. premium", "Ave. Ins. Losses"]
    dotplots = []
    for i of top_panel_var

        this_dotplot = scatterplot().width(panelwidth_top)
                                    .height(panelheight_top)
                                    .margin(margin_top)
                                    .xNA({handle:false})
                                    .yNA({handle:false})
                                    .xlim(xlim[i])
                                    .ylim([0.5, n_states+0.5])
                                    .yticks(d3.range(n_states).map (d) -> d+1)
                                    .xlab(xlab[i])
                                    .ylab("")
                                    .dataByInd(false)
                                    .xvar(top_panel_var[i])
                                    .yvar("rank")
                                    .title(title[i])
        dotplots.push(this_dotplot)

        this_g = svg.append("g")
                    .attr("id", "dotplot#{i}")
                    .attr("transform", "translate(#{statenamewidth+i*fullpanelwidth_top},0)")

        this_g.datum({data:data, indID:data.abbrev})
              .call(this_dotplot)

        d3.selectAll("g.y.axis line").attr("stroke", "#bbb")

    # add state names
    yscale = dotplots[0].yscale()
    state_names = svg.append("g").attr("id", "statenames")
                     .selectAll("empty")
                     .data(data.state)
                     .enter()
                     .append("text")
                     .text((d) -> d)
                     .attr("x", statenamewidth)
                     .attr("y", (d,i) -> yscale(data.rank[i]))
                     .style("font-size", "8pt")
                     .style("dominant-baseline", "middle")
                     .style("text-anchor", "end")
                     .attr("id", (d,i) -> "text#{i}")

    # add x-axis label for first four panels
    svg.append("g").attr("class", "x axis")
       .append("text")
       .attr("x", statenamewidth + 2*fullpanelwidth_top)
       .attr("y", margin_top.top + panelheight_top + 25)
       .attr("class", "title")
       .text("Crashes per billion miles")

# load the data and make the plot
d3.json("data.json", plot)

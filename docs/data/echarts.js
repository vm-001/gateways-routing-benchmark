option = {
    backgroundColor: '#111518',
    title: {
        text: 'API Gateway Routing Performance',
        subtext: "AmazonEC2 c5.xlarge"
    },
    legend: {
        // left: 'right'
    },
    tooltip: {
        trigger: 'axis',
        axisPointer: {
            type: 'shadow'
        }
    },
    grid: [{ bottom: '56%' }, { top: '56%' }],
    dataset: {
        source: [
            [
                'API Gateway',
                'Kong (Radix-Router) ',
                'APISIX',
                'Tyk',
                'Kong (Radix-Router) ',
                'APISIX',
                'Tyk'
            ],
            ['Single-Static(1 routes)', 14449.36, 17993.28, 7281.20, 25.60, 17.38, 54.23],
            ['OpenAI(36 routes)',       11821.88, 10494.82,  6999.82, 38.21, 53.58, 57.46],
            ['Okta(217 routes)',        11296.29,  9370.51, 6908.12, 50.68, 66.20, 59.37],
            ['GitHub(609 routes)',      12020.59,  3503.27,  2524.65, 34.49, 96.92, 121.64],
        ]
    },
    xAxis: [
        {
            type: 'category',
            gridIndex: 0,
            name: 'Benchmark Cases (higher is better)',
            nameLocation: 'middle',
            nameGap: 30
        },
        {
            type: 'category',
            gridIndex: 1,
            name: 'Benchmark Cases (lower is better)',
            nameLocation: 'middle',
            nameGap: 30
        }
    ],
    yAxis: [
        { gridIndex: 0, name: 'RPS', nameLocation: 'middle', nameGap: 50 },
        { gridIndex: 1, name: 'P99 (ms)', nameLocation: 'middle', nameGap: 50 }
    ],

    series: [
        // These series are in the first grid.
        { xAxisIndex: 0, yAxisIndex: 0, type: 'bar', barWidth: "14%", barGap: "56%", itemStyle: { color: '#2a5eba' } },
        { xAxisIndex: 0, yAxisIndex: 0, type: 'bar', barWidth: "14%", barGap: "56%", itemStyle: { color: '#797272' } },
        { xAxisIndex: 0, yAxisIndex: 0, type: 'bar', barWidth: "14%", barGap: "56%", itemStyle: { color: '#b3bac6' } },

        // These series are in the second grid.
        { xAxisIndex: 1, yAxisIndex: 1, type: 'bar', barWidth: "14%", barGap: "56%", itemStyle: { color: '#2a5eba' } },
        { xAxisIndex: 1, yAxisIndex: 1, type: 'bar', barWidth: "14%", barGap: "56%", itemStyle: { color: '#797272' } },
        { xAxisIndex: 1, yAxisIndex: 1, type: 'bar', barWidth: "14%", barGap: "56%", itemStyle: { color: '#b3bac6' } },
    ]
};

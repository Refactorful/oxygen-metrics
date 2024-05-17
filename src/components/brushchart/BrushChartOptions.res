%raw(`
    function countLeadingZeros(number) {
    // Check if number is null or undefined
    if (number === null || number === undefined) {
      throw new Error("Input is null or undefined");
    }
  
    // Convert the number to a string
    let str = number.toString();
  
    // Early return if the number is an integer
    if (!str.includes('.')) {
      return 3;
    }
  
    // Split the string at the decimal point and take the decimal part
    let decimalPart = str.split(".")[1];
  
    // Start with a minimum precision of 3
    let count = 2;
  
    // Use while loop for counting leading zeros
    let i = 0;
    while (i < decimalPart.length && decimalPart[i] === '0') {
      count++;
      i++;
    }
  
    return count;
  }
`)

let countLeadingZeros = (number: float) => {
  let str = Js.Float.toString(number)

  if !Js.String.includes(".", str) {
    0
  } else {
    let decimalPart = Js.String.split(".", str)->Belt.Array.get(1)->Belt.Option.getWithDefault("")
    let count = ref(0)
    let i = ref(0)
    let len = Js.String.length(decimalPart)
    while i.contents < len && Js.String.get(decimalPart, i.contents) == "0" {
      count := count.contents + 1
      i := i.contents + 1
    }
    count.contents
  }
}

// countLeadingZeros(0.000332) -> Js.log

let yaxisFormatter = %raw(`
    function(value, unit=null) {
        let formatted = value;
        // Check if the value has more than three decimal places
        if (value % 1 !== 0) {
            formatted = parseFloat(value).toFixed(countLeadingZeros(value));
        }
        // If it doesn't have more than three decimal places, leave it as is
        return unit ? formatted + unit : formatted;
    }
`)

let getChartOpts = (label, range, unit) =>
  {
    "chart": {
      "id": label,
      "type": "line",
      "toolbar": {
        "autoSelected": "pan",
        "show": false,
        "tools": {
          "zoom": false,
          "zoomin": false,
          "zoomout": false,
          "selection": false,
          "reset": false,
        },
      },
    },
    "tooltip": {
      "theme": "dark",
    },
    "stroke": {
      "width": 2,
    },
    "dataLabels": {
      "enabled": false,
    },
    "markers": {
      "size": 0,
    },
    "colors": ["#0BC5EA", "#2D3748"],
    "xaxis": {
      "type": "datetime",
      "range": range,
      "tickAmount": 3,
      "labels": {
        "formatter": value => {
          Js.Date.fromFloat(value)->Js.Date.toLocaleDateString
        },
        "style": {
          "colors": "#c8cfca",
          "fontSize": "12px",
        },
      },
    },
    "yaxis": {
      "labels": {
        "style": {
          "colors": "#c8cfca",
          "fontSize": "12px",
        },
        "formatter": value => yaxisFormatter(value, unit),
      },
    },
  }

let getLineOpts = (label, target, unit, fillColor, strokeColor) =>
  {
    "chart": {
      "id": label,
      "height": 130,
      "type": "area",
      "brush": {
        "target": target,
        "enabled": true,
      },
      "selection": {
        "enabled": true,
        "fill": {
          "color": fillColor,
          "opacity": 0.1,
        },
        "stroke": {
          "width": 1,
          "dashArray": 3,
          "color": strokeColor,
          "opacity": 1,
        },
      },
      //   "events": {
      //     brushScrolled: function (chartContext, { xaxis, yaxis }) {
      //       onBrushUpdate(chartContext, xaxis)
      //     }
      //   },
    },
    "stroke": {
      "width": 1,
    },
    "colors": ["#0BC5EA", "#2D3748"],
    "xaxis": {
      "type": "datetime",
      "tickAmount": 3,
      "labels": {
        "formatter": value => {
          Js.Date.fromFloat(value)->Js.Date.toLocaleDateString
        },
        "style": {
          "colors": "#c8cfca",
          "fontSize": "12px",
        },
      },
    },
    "yaxis": {
      "tickAmount": 2,
      "labels": {
        "style": {
          "colors": "#c8cfca",
          "fontSize": "12px",
        },
        "formatter": value => yaxisFormatter(value, unit),
      },
    },
  }

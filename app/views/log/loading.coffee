effect = ["spin", "bar", "ring", "whirling", "dynamicLine", "bubble"]

module.exports = (effectIndex) ->
    text : effect[effectIndex],
    effect : effect[effectIndex],
    textStyle : {
        fontSize : 20
    }


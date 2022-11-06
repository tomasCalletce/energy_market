const axios = require('axios');

async function getPrice(date){
    const res = await axios.post('http://servapibi.xm.com.co/hourly', {
        MetricId: "PrecPromContRegu",
        StartDate: date,
        EndDate: date,
        Entity : "Sistema"
    })
    const priceDataByHour = res.data.Items[0].HourlyEntities[0].Values
    const price = getArithmeticMean(priceDataByHour)
    return price
}

function getArithmeticMean(prices){
    let val = 0
    for(let i = 1;i<25;i++){
        if(i<10){
            val = val + Number(prices[`Hour0${i}`])
        }else{
            val = val + Number(prices[`Hour${i}`])
        }
    }
    return val/24;
}

module.exports = { getPrice }
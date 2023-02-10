const today = new Date();
const dd = String(today.getDate()).padStart(2, '0');
const mm = String(today.getMonth() + 1).padStart(2, '0');
const yyyy = today.getFullYear();

today = dd + '-' + mm + '-' + yyyy;

$.ajax({
  url: "https://odegdcpnma.execute-api.eu-west-2.amazonaws.com/development/prices?dno=14&voltage=HV&start=" + today + "&end=" + today,
  success: function(data) {
    const electricity_price = data['data']['data'][0]['Overall']; 
    //hier halen wij de prijs van electriciteit op - hebben deze value in het model nodig
    //Is het modelijk om deze dan te gebruiken in de get_current_electricty_price functie in cost_calculation_service.rb?
    // default fallback value in .env is er al: COSTS_WHOLESALE_ELECTRICITY
    console.log(electricity_price);
  }
});
import sliderConfig from './config.js';

document.addEventListener('DOMContentLoaded', () => {
  const sliderEl2 = document.querySelector("#range2");
  const sliderValue2 = document.querySelector(".value2");

  const sliderEl3 = document.querySelector("#range3");
  const sliderValue3 = document.querySelector(".value3");

  const sliderEl4 = document.querySelector("#range4");
  const sliderValue4 = document.querySelector(".value4");

  function updateSliderBackground(sliderEl, value, max, color1, color2) {
    const progress = (value / max) * 100;
    sliderEl.style.background = `linear-gradient(to right, ${color1} ${progress}%, ${color2} ${progress}%)`;
  }

  if (sliderEl2) {
    sliderEl2.addEventListener("input", (event) => {
      const tempSliderValue2 = event.target.value; 
      sliderValue2.textContent = tempSliderValue2;
      updateSliderBackground(sliderEl2, tempSliderValue2, sliderEl2.max, '#16905B', '#0D3A2A');
    });
  }

  if (sliderEl3) {
    sliderEl3.addEventListener("input", (event) => {
      const tempSliderValue3 = event.target.value; 
      sliderValue3.textContent = tempSliderValue3;
      updateSliderBackground(sliderEl3, tempSliderValue3, sliderEl3.max, '#3BD1D5', '#0A3373');
    });
  }

  if (sliderEl4) {
    sliderEl4.addEventListener("input", (event) => {
      const tempSliderValue4 = event.target.value; 
      sliderValue4.textContent = tempSliderValue4;
      updateSliderBackground(sliderEl4, tempSliderValue4, sliderEl4.max, '#40D47E', '#555033');
    });
  }

  window.addEventListener("message", function (event) {
    console.log("NUI message received", event.data);
    if (event.data.type === "open") {
      document.body.style.display = 'block';
      document.body.style.opacity = '100';
    }
  });

  document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
      // Send the POST request to close the interface
      $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ }), function (x) {});
      // Trigger the fade-out animation
      document.body.style.display = 'none'; // Hide the body after the fade-out animation
     // Duration should match the fade-out animation duration
    }
  });

  const cardBoxBottom = document.querySelector(".card-box-bottom");
  if (cardBoxBottom) {
    cardBoxBottom.addEventListener("click", function () {
      if (!sliderEl2 || !sliderEl3 || !sliderEl4) {
        console.error("One or more sliders not found.");
        return;
      }

      const totalValue = parseInt(sliderEl2.value) + parseInt(sliderEl3.value) + parseInt(sliderEl4.value);
      console.log("Total value:", totalValue);

      let match = false;

      // Check if the slider values match the configuration
      if (parseInt(sliderEl2.value) === sliderConfig.slider1 &&
          parseInt(sliderEl3.value) === sliderConfig.slider2 &&
          parseInt(sliderEl4.value) === sliderConfig.slider3) {
        console.log("match");
        match = true;
      }

      // Send data to the Lua script via NUI callback
      fetch(`https://${GetParentResourceName()}/confirm`, {
          method: 'POST',
          headers: {
              'Content-Type': 'application/json; charset=UTF-8',
          },
          body: JSON.stringify({ match: match })
      }).then(resp => resp.json())
        .then(resp => console.log("Response from Lua:", resp))
        .catch(error => console.error("Error:", error));
        
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ }), function (x) {});
        document.body.style.display = 'none';
    });
  }
});

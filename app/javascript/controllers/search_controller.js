import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results", "selectedValue"];
  static debounceTime = 300; // 300ms debounce time
  searchTimeout = null;

  search() {
    clearTimeout(this.searchTimeout); // Clear the previous timeout if it exists

    this.searchTimeout = setTimeout(() => {
      const input = this.inputTarget.value;
      fetch(`/forecasts/search?query=${input}`)
        .then(response => response.json())
        .then(data => {
          console.log("DATA", data)
          this.updateResults(data);
        })
        .catch(error => {
          console.error("Error fetching data: ", error);
        });
    }, this.constructor.debounceTime); // Set a timeout for executing the function
  }

  updateResults(data) {
    const resultsContainer = this.resultsTarget;
    resultsContainer.innerHTML = ""; // clear existing results

    const dropdownWrapper = document.createElement("div");
    dropdownWrapper.className = "dropdown-list";

    data.coordinates.forEach(item => {
      const listItem = document.createElement("li");
      listItem.textContent = JSON.parse(item).display_name;
      listItem.addEventListener("click", () => {
        this.selectResult(item);
      });
      dropdownWrapper.appendChild(listItem);
    });

    resultsContainer.appendChild(dropdownWrapper);
  }

  selectResult(item) {
    this.inputTarget.value = JSON.parse(item).display_name;

    // Serialize the item object and set it to the hidden input
    this.selectedValueTarget.value = item;

    this.resultsTarget.innerHTML = "";
  }
}

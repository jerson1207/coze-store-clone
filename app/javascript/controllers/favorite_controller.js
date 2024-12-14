import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="favorite"
export default class extends Controller {
  static values = { productId: Number }

  async toggleFavorite(event) {
    event.preventDefault();

    try {
      const response = await fetch(`/favorites/${this.productIdValue}/toggle`, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
          "Content-Type": "application/json",
        },
      });

      if (!response.ok) {
        throw new Error("Network response was not ok");
      }

      const data = await response.json();

      // Update UI based on the response
      if (data.status === "added") {
        this.element.classList.remove("fa-regular");
        this.element.classList.add("fa-solid");
      } else if (data.status === "removed") {
        this.element.classList.remove("fa-solid");
        this.element.classList.add("fa-regular");
      }
    } catch (error) {
      console.error("Error:", error);
    }
    
  }
}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart"
export default class extends Controller {
  static targets = ["button"];

  async addToCart(event) {
    event.preventDefault();

    const productId = this.element.dataset.productid;
    const url = `/cart_items/${productId}/add_item`;

    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Content-Type": "application/json"
        }
      });

      if (response.ok) {
        const result = await response.json();
        console.log("Item added to cart:", result);
        // Optionally, update the UI (e.g., cart count)
      } else {
        console.error("Failed to add item to cart:", response.statusText);
      }
    } catch (error) {
      console.error("Error:", error);
    }
  }
}

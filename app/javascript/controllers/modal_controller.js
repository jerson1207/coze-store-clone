import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static values = { content: String };

  open(event) {
    event.preventDefault();

    // Check if a modal is already open and close it
    this.closeModal();

    // Get product ID and name from data attributes
    const productId = event.target.dataset.productId;
    const productName = event.target.dataset.productName;

    // Create modal HTML dynamically
    const modal = document.createElement("div");
    modal.innerHTML = this.modalHTML(productId, productName);

    // Append the modal to the body
    document.body.appendChild(modal.firstElementChild);

    // Add event listener to close the modal when clicking outside
    this.addCloseOnBackgroundClick();
  }

  close(event) {
    event.preventDefault();
    this.closeModal();
  }

  closeModal() {
    // Remove any existing modal from the DOM
    const existingModal = document.getElementById("myModal");
    if (existingModal) {
      existingModal.remove();
    }
  }

  addCloseOnBackgroundClick() {
    // Find the modal container
    const modal = document.getElementById("myModal");

    // Close modal if clicking on the background (outside the modal content)
    modal.addEventListener('click', (event) => {
      if (event.target === modal) {
        this.closeModal();  // Close the modal if clicked on background
      }
    });
  }

  modalHTML(productId, productName) {
    const addToCartPath = `/cart_items/${productId}/add_item`; // Replace with your actual route path

    return `
      <div id="myModal" class="fixed inset-0 bg-gray-800 bg-opacity-95 grid place-items-center z-50" data-controller="modal">
        <div class="relative bg-white p-8 rounded-lg shadow-lg w-2/3">
          <button class="close-button absolute top-2 right-2 text-gray-700 hover:text-gray-900"
                data-action="click->modal#close">
            &times;
          </button>

          <h2 class="text-xl font-bold mb-4 text-center">Product: ${productName}</h2>
          <p class="mb-4 text-center">Product ID: ${productId}</p>

          <!-- Add to Cart Button -->
          <form action="${addToCartPath}" method="post" data-turbo="true">
            <button type="submit" 
                    class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600">
              Add to cart
            </button>
          </form>
        </div>
      </div>
    `;
  }
}

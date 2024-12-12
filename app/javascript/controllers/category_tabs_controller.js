import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="category-tabs"
export default class extends Controller {
  static targets = ["allButton"];
  connect() {
    if (this.hasAllButtonTarget) {
      this.setActiveTab(this.allButtonTarget);
      this.showAllProducts()
    }
  }
  filterAll(event) {
    event.preventDefault();
    this.showAllProducts();
    this.setActiveTab(event.target);
  }
  filterCategory(event) {
    event.preventDefault();
    const categoryId = event.target.getAttribute("data-category-id");
    this.showProductsByCategory(categoryId);
    this.setActiveTab(event.target);
  }
  showAllProducts() {
    document.querySelectorAll('.product-item').forEach(product => {
      product.classList.remove('hidden');
    });
  }
  showProductsByCategory(categoryId) {
    document.querySelectorAll('.product-item').forEach(product => {
      const categoryIds = product.getAttribute("data-category-ids").split(',');
      if (categoryIds.includes(categoryId)) {
        product.classList.remove('hidden');
      } else {
        product.classList.add('hidden');
      }
    });
  }
  setActiveTab(button) {
    const allButtons = this.element.querySelectorAll('button');
    allButtons.forEach(btn => btn.classList.remove('active'));
    button.classList.add('active');
  }
}

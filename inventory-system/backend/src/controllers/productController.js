const { products } = require('../data/data');

// Get all products
const getProducts = (req, res) => {
    res.json(products);
};

// Add new product (admin only)
const addProduct = (req, res) => {
    const { name, description, quantity, price } = req.body;

    const newProduct = {
        id: products.length + 1,
        name,
        description,
        quantity: parseInt(quantity),
        price: parseFloat(price)
    };

    products.push(newProduct);
    res.status(201).json(newProduct);
};

// Remove product (admin only)
const removeProduct = (req, res) => {
    const productId = parseInt(req.params.id);
    const productIndex = products.findIndex(p => p.id === productId);

    if (productIndex === -1) {
        return res.status(404).json({ message: 'Product not found' });
    }

    products.splice(productIndex, 1);
    res.json({ message: 'Product removed successfully' });
};

// Update product quantity (admin only)
const updateQuantity = (req, res) => {
    const productId = parseInt(req.params.id);
    const { quantity } = req.body;
    
    const product = products.find(p => p.id === productId);
    
    if (!product) {
        return res.status(404).json({ message: 'Product not found' });
    }

    product.quantity = parseInt(quantity);
    res.json(product);
};

// Remove quantity from product (both admin and regular users)
const removeQuantity = (req, res) => {
    const productId = parseInt(req.params.id);
    const { quantity } = req.body;
    
    const product = products.find(p => p.id === productId);
    
    if (!product) {
        return res.status(404).json({ message: 'Product not found' });
    }

    if (product.quantity < quantity) {
        return res.status(400).json({ message: 'Insufficient quantity available' });
    }

    product.quantity -= parseInt(quantity);
    res.json(product);
};

module.exports = {
    getProducts,
    addProduct,
    removeProduct,
    updateQuantity,
    removeQuantity
};
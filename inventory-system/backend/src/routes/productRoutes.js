const express = require('express');
const { body } = require('express-validator');
const router = express.Router();
const { 
    getProducts, 
    addProduct, 
    removeProduct, 
    updateQuantity, 
    removeQuantity 
} = require('../controllers/productController');
const authenticate = require('../middlewares/authenticate');
const authorize = require('../middlewares/authorize');

// All routes require authentication
router.use(authenticate);

// Get all products (both admin and regular users)
router.get('/', getProducts);

// Admin only routes
router.post('/', authorize, [
    body('name').notEmpty().withMessage('Name is required'),
    body('description').notEmpty().withMessage('Description is required'),
    body('quantity').isInt({ min: 0 }).withMessage('Quantity must be a positive number'),
    body('price').isFloat({ min: 0 }).withMessage('Price must be a positive number')
], addProduct);

router.delete('/:id', authorize, removeProduct);

router.put('/:id/quantity', authorize, [
    body('quantity').isInt({ min: 0 }).withMessage('Quantity must be a positive number')
], updateQuantity);

// Both admin and regular users can remove quantity
router.patch('/:id/quantity/remove', [
    body('quantity').isInt({ min: 1 }).withMessage('Quantity must be at least 1')
], removeQuantity);

module.exports = router;
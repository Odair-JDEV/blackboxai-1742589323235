const express = require('express');
const { body } = require('express-validator');
const router = express.Router();
const { getUsers, addUser, removeUser } = require('../controllers/userController');
const authenticate = require('../middlewares/authenticate');
const authorize = require('../middlewares/authorize');

// All routes require authentication and admin authorization
router.use(authenticate, authorize);

// Get all users
router.get('/', getUsers);

// Add new user
router.post('/', [
    body('name').notEmpty().withMessage('Name is required'),
    body('email').isEmail().withMessage('Please enter a valid email'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters long'),
    body('role').isIn(['admin', 'user']).withMessage('Role must be either admin or user')
], addUser);

// Remove user
router.delete('/:id', removeUser);

module.exports = router;
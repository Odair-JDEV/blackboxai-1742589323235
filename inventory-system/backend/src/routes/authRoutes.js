const express = require('express');
const { body } = require('express-validator');
const router = express.Router();
const { login } = require('../controllers/authController');

router.post('/login', [
    body('email').isEmail().withMessage('Please enter a valid email'),
    body('password').notEmpty().withMessage('Password is required')
], login);

module.exports = router;
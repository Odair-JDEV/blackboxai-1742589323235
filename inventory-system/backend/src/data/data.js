const bcrypt = require('bcryptjs');

// Initial users with hashed passwords
const users = [
    {
        id: 1,
        name: 'Admin User',
        email: 'admin@example.com',
        password: bcrypt.hashSync('admin123', 10),
        role: 'admin'
    },
    {
        id: 2,
        name: 'Regular User',
        email: 'user@example.com',
        password: bcrypt.hashSync('user123', 10),
        role: 'user'
    }
];

// Initial products
const products = [
    {
        id: 1,
        name: 'Product 1',
        description: 'Description for Product 1',
        quantity: 100,
        price: 29.99
    },
    {
        id: 2,
        name: 'Product 2',
        description: 'Description for Product 2',
        quantity: 150,
        price: 39.99
    }
];

module.exports = {
    users,
    products
};
const bcrypt = require('bcryptjs');
const { users } = require('../data/data');

// Get all users (admin only)
const getUsers = (req, res) => {
    const usersList = users.map(({ password, ...user }) => user);
    res.json(usersList);
};

// Add new user (admin only)
const addUser = (req, res) => {
    const { name, email, password, role } = req.body;

    // Check if email already exists
    if (users.find(u => u.email === email)) {
        return res.status(400).json({ message: 'Email already registered' });
    }

    // Create new user
    const newUser = {
        id: users.length + 1,
        name,
        email,
        password: bcrypt.hashSync(password, 10),
        role: role || 'user' // Default to 'user' if role not specified
    };

    users.push(newUser);

    // Return user without password
    const { password: _, ...userWithoutPassword } = newUser;
    res.status(201).json(userWithoutPassword);
};

// Remove user (admin only)
const removeUser = (req, res) => {
    const userId = parseInt(req.params.id);
    const userIndex = users.findIndex(u => u.id === userId);

    if (userIndex === -1) {
        return res.status(404).json({ message: 'User not found' });
    }

    // Prevent admin from deleting themselves
    if (users[userIndex].id === req.user.id) {
        return res.status(400).json({ message: 'Cannot delete your own admin account' });
    }

    users.splice(userIndex, 1);
    res.json({ message: 'User removed successfully' });
};

module.exports = {
    getUsers,
    addUser,
    removeUser
};
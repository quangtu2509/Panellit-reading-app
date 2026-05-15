const { z } = require('zod');

const registerSchema = z.object({
  email: z
    .string({ required_error: 'Email is required' })
    .email('Invalid email format')
    .toLowerCase()
    .trim(),
  password: z
    .string({ required_error: 'Password is required' })
    .min(6, 'Password must be at least 6 characters'),
});

const loginSchema = z.object({
  email: z
    .string({ required_error: 'Email is required' })
    .email('Invalid email format')
    .toLowerCase()
    .trim(),
  password: z
    .string({ required_error: 'Password is required' })
    .min(1, 'Password is required'),
});

const updateNameSchema = z.object({
  name: z
    .string({ required_error: 'Name is required' })
    .min(1, 'Name cannot be empty')
    .max(100, 'Name is too long')
    .trim(),
});

const updatePasswordSchema = z.object({
  currentPassword: z
    .string({ required_error: 'currentPassword is required' })
    .min(1, 'currentPassword is required'),
  newPassword: z
    .string({ required_error: 'newPassword is required' })
    .min(6, 'New password must be at least 6 characters'),
});

module.exports = { registerSchema, loginSchema, updateNameSchema, updatePasswordSchema };

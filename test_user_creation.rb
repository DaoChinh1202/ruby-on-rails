#!/usr/bin/env ruby

# Test script to demonstrate user creation debugging
# Run with: rails runner test_user_creation.rb

puts "=== Testing User Creation Debug Flow ==="

# Test 1: Successful creation
puts "\n🧪 Test 1: Valid user creation"
puts "-" * 40

# Simulate controller params
test_params_valid = {
  "user" => {
    "name" => "John Doe", 
    "email" => "john.doe@example.com"
  },
  "controller" => "users",
  "action" => "create"
}

puts "Simulating POST /users with params:"
puts test_params_valid.inspect

# Create user directly (this will show our debug output)
user1 = User.new(test_params_valid["user"])
puts "\nCreated user instance: #{user1.inspect}"
puts "Valid? #{user1.valid?}"
puts "Errors: #{user1.errors.full_messages}" unless user1.valid?

if user1.save
  puts "✅ User saved successfully with ID: #{user1.id}"
else
  puts "❌ User save failed: #{user1.errors.full_messages}"
end

# Test 2: Failed creation
puts "\n🧪 Test 2: Invalid user creation"
puts "-" * 40

test_params_invalid = {
  "user" => {
    "name" => "", 
    "email" => "invalid-email"
  },
  "controller" => "users",
  "action" => "create"
}

puts "Simulating POST /users with invalid params:"
puts test_params_invalid.inspect

user2 = User.new(test_params_invalid["user"])
puts "\nCreated user instance: #{user2.inspect}"
puts "Valid? #{user2.valid?}"
puts "Errors: #{user2.errors.full_messages}" unless user2.valid?

if user2.save
  puts "✅ User saved successfully with ID: #{user2.id}"
else
  puts "❌ User save failed: #{user2.errors.full_messages}"
end

puts "\n=== Test Complete ==="
puts "\n💡 Tips:"
puts "1. Check log/development.log for detailed debug output"
puts "2. Use 'rails console' for interactive testing"
puts "3. Add 'byebug' in controller for step-by-step debugging"
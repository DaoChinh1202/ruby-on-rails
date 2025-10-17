# User Creation Debug Guide

## Rails Action Lifecycle for User Creation

### 1. Request Processing Flow
```
HTTP POST /users
    ↓
Rails Router (routes.rb)
    ↓
UsersController#create
    ↓
Before Actions (if any)
    ↓
Action Method Execution
    ↓
Response Rendering/Redirect
    ↓
After Actions (if any)
```

### 2. Step-by-Step Debug Analysis

#### Phase 1: Request Reception
- **Step 1**: Rails receives POST request to `/users`
- **Step 2**: Router matches route to `UsersController#create`
- **Step 3**: Parameters are parsed from request body

#### Phase 2: Parameter Processing  
- **Step 4**: `user_params` method filters parameters
- **Step 5**: Only `:name` and `:email` are allowed through
- **Step 6**: Creates hash with permitted parameters

#### Phase 3: Model Creation
- **Step 7**: `User.new()` creates new User instance
- **Step 8**: Attributes are assigned to the model
- **Step 9**: Model validations are checked (but not enforced yet)

#### Phase 4: Persistence Attempt
- **Step 10**: `@user.save` attempts to save to database
- **Step 11a**: If successful → database record created
- **Step 11b**: If failed → validation errors populated

#### Phase 5: Response Generation
- **Step 12a**: Success path → Redirect to user show page
- **Step 12b**: Failure path → Render new form with errors

## Debug Output Analysis

### Successful Creation Log Example:
```
=== CREATE USER ACTION STARTED ===
Step 1: Received params: {"user"=>{"name"=>"John Doe", "email"=>"john@example.com"}, "controller"=>"users", "action"=>"create"}
Step 2: Extracting user_params...
Parameter filtering: Raw params = {"user"=>{"name"=>"John Doe", "email"=>"john@example.com"}, "controller"=>"users", "action"=>"create"}
Parameter filtering: Filtered params = {"name"=>"John Doe", "email"=>"john@example.com"}
Step 3: Filtered params: {"name"=>"John Doe", "email"=>"john@example.com"}
Step 4: Creating new User instance...
Step 5: User instance created: #<User id: nil, name: "John Doe", email: "john@example.com", created_at: nil, updated_at: nil>
Step 6: User attributes: {"id"=>nil, "name"=>"John Doe", "email"=>"john@example.com", "created_at"=>nil, "updated_at"=>nil}
Step 7: User valid? true
Step 9: Attempting to save user...
Step 10: ✅ User saved successfully! ID: 42
Step 11: Redirecting to user show page...
=== CREATE USER ACTION COMPLETED ===
```

### Failed Creation Log Example:
```
=== CREATE USER ACTION STARTED ===
Step 1: Received params: {"user"=>{"name"=>"", "email"=>"invalid-email"}, "controller"=>"users", "action"=>"create"}
Step 2: Extracting user_params...
Step 3: Filtered params: {"name"=>"", "email"=>"invalid-email"}
Step 4: Creating new User instance...
Step 5: User instance created: #<User id: nil, name: "", email: "invalid-email", created_at: nil, updated_at: nil>
Step 6: User attributes: {"id"=>nil, "name"=>"", "email"=>"invalid-email", "created_at"=>nil, "updated_at"=>nil}
Step 7: User valid? false
Step 8: Validation errors: ["Name can't be blank", "Email is invalid"]
Step 9: Attempting to save user...
Step 10: ❌ User save failed!
Step 11: Save errors: ["Name can't be blank", "Email is invalid"]
Step 12: Rendering new form with errors...
=== CREATE USER ACTION COMPLETED ===
```

## How to Monitor Debug Output

### 1. Development Server
```bash
# Start Rails server with verbose logging
rails server

# In another terminal, tail the logs
tail -f log/development.log | grep "CREATE USER"
```

### 2. Rails Console
```ruby
# Test user creation directly
User.create(name: "Test User", email: "test@example.com")
```

### 3. Browser Developer Tools
- Open Network tab
- Submit user creation form
- Check request/response details

## Common Debug Scenarios

### 1. Parameters Not Received
**Symptom**: Empty or missing params
**Check**: Form field names match expected parameters

### 2. Validation Failures
**Symptom**: User save fails with validation errors
**Check**: Model validations and input data

### 3. Strong Parameters Issues
**Symptom**: Unpermitted parameters error
**Check**: `user_params` method allows required fields

### 4. Database Constraints
**Symptom**: Database-level errors during save
**Check**: Database constraints and unique indexes

## Additional Debug Tools

### 1. Add Byebug Breakpoints
```ruby
def create
  byebug  # Execution will pause here
  @user = User.new(user_params)
  # ... rest of method
end
```

### 2. Use Rails Logger Levels
```ruby
Rails.logger.debug "Debug info"
Rails.logger.info "General info" 
Rails.logger.warn "Warning message"
Rails.logger.error "Error occurred"
```

### 3. Custom Debug Helper
```ruby
private

def debug_step(step_number, message, object = nil)
  Rails.logger.debug "Step #{step_number}: #{message}"
  Rails.logger.debug "Object: #{object.inspect}" if object
end
```
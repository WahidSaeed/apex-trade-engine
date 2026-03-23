-- 1. Ensure foreign keys exist between user_roles and users/roles
ALTER TABLE auth_schema.user_roles 
    ADD CONSTRAINT fk_user_id 
    FOREIGN KEY (user_id) REFERENCES auth_schema.users(id) ON DELETE CASCADE;

ALTER TABLE auth_schema.user_roles 
    ADD CONSTRAINT fk_role_id 
    FOREIGN KEY (role_id) REFERENCES auth_schema.roles(id) ON DELETE CASCADE;

-- 2. Indexing for fast security checks during login
CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON auth_schema.user_roles(user_id);
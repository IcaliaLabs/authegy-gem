#! /bin/sh

rm -rf spec/dummy/app/models/person.rb \
       spec/dummy/app/models/role_assignment.rb \
       spec/dummy/app/models/role.rb \
       spec/dummy/app/models/user.rb \
       spec/dummy/config/initializers/devise.rb \
       spec/dummy/config/locales/devise.en.yml \
       spec/dummy/db/migrate/*_enable_pgcrypto_extension.rb \
       spec/dummy/db/migrate/*_create_authegy_model_tables.rb \
       spec/dummy/spec/models/user_spec.rb

SELECT DISTINCT "user_groups".*
FROM
  "user_groups"
  LEFT OUTER JOIN (
    SELECT "role_assignments"."actor_id", "role_assignments"."resource_id"
    FROM
      "role_assignments"
      INNER JOIN "roles" ON "roles"."id" = "role_assignments"."role_id"
    WHERE
      "role_assignments"."resource_type" = 'UserGroup'
      AND "roles"."name" IN ('member', 'moderator')
  ) "user_group_role_assignments" ON
    "user_groups"."id" = "user_group_role_assignments"."resource_id"
WHERE 1 IN (
  "user_groups"."owner_id",
  "user_group_role_assignments"."actor_id"
)

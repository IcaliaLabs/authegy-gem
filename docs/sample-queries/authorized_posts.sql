SELECT DISTINCT "group_posts".*
FROM
  "group_posts"
  INNER JOIN "user_groups" ON "user_groups"."id" = "group_posts"."group_id"
  LEFT OUTER JOIN (
    SELECT "role_assignments"."actor_id", "role_assignments"."resource_id"
    FROM "role_assignments"
    INNER JOIN "roles" ON "roles"."id" = "role_assignments"."role_id"
    WHERE
      "role_assignments"."resource_type" = 'UserGroup'
      AND "roles"."name" IN ('moderator', 'member')
  ) "group_role_assignments" ON
    "user_groups"."id" = "group_role_assignments"."resource_id"
WHERE
  1 IN (
    "group_posts"."author_id",
    "user_groups"."owner_id",
    "group_role_assignments"."actor_id"
  )
  AND "group_posts"."group_id" = ?

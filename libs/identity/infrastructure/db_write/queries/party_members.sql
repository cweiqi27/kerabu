-- name: CreatePartyMember :one
INSERT INTO party_members (party_id, user_id, role, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: RemovePartyMember :exec
DELETE FROM party_members
WHERE party_id = $1 AND user_id = $2;

-- name: UpdatePartyMemberRole :exec
UPDATE party_members SET
  role = $3,
  updated_at = $4
WHERE party_id = $1 AND user_id = $2;

-- name: GetPartyMember :one
SELECT * FROM party_members
WHERE party_id = $1 AND user_id = $2;

;; usage-tracking.clar
;; Monitors utilization of licensed IP across industries

(define-map usage-records
  { usage-id: uint }
  {
    license-id: uint,
    amount: uint,
    timestamp: uint
  }
)

(define-data-var last-usage-id uint u0)

(define-public (record-usage (license-id uint) (amount uint))
  (let
    (
      (new-usage-id (+ (var-get last-usage-id) u1))
    )
    (var-set last-usage-id new-usage-id)
    (ok (map-set usage-records
      { usage-id: new-usage-id }
      {
        license-id: license-id,
        amount: amount,
        timestamp: block-height
      }
    ))
  )
)

(define-read-only (get-usage (usage-id uint))
  (map-get? usage-records { usage-id: usage-id })
)


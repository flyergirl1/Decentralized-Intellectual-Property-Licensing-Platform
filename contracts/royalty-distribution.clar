;; royalty-distribution.clar
;; Automates payments to IP owners based on usage

(define-map royalty-payments
  { payment-id: uint }
  {
    asset-id: uint,
    amount: uint,
    paid-at: uint
  }
)

(define-data-var last-payment-id uint u0)

(define-public (distribute-royalties (asset-id uint) (amount uint) (royalty-rate uint))
  (let
    (
      (royalty-amount (/ (* amount royalty-rate) u100))
      (new-payment-id (+ (var-get last-payment-id) u1))
    )
    (var-set last-payment-id new-payment-id)
    (ok (map-set royalty-payments
      { payment-id: new-payment-id }
      {
        asset-id: asset-id,
        amount: royalty-amount,
        paid-at: block-height
      }
    ))
  )
)

(define-read-only (get-royalty-payment (payment-id uint))
  (map-get? royalty-payments { payment-id: payment-id })
)


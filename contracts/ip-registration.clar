;; ip-registration.clar
;; Records ownership of patents, trademarks, and copyrights

(define-map ip-assets
  { asset-id: uint }
  {
    owner: principal,
    ip-type: (string-ascii 20),
    description: (string-ascii 256)
  }
)

(define-data-var last-asset-id uint u0)

(define-read-only (get-ip-asset (asset-id uint))
  (map-get? ip-assets { asset-id: asset-id })
)

(define-public (register-ip-asset (ip-type (string-ascii 20)) (description (string-ascii 256)))
  (let
    (
      (new-asset-id (+ (var-get last-asset-id) u1))
    )
    (var-set last-asset-id new-asset-id)
    (ok (map-set ip-assets
      { asset-id: new-asset-id }
      {
        owner: tx-sender,
        ip-type: ip-type,
        description: description
      }
    ))
  )
)

(define-public (transfer-ip-asset (asset-id uint) (new-owner principal))
  (let
    (
      (asset (unwrap! (get-ip-asset asset-id) (err u404)))
    )
    (asserts! (is-eq (get owner asset) tx-sender) (err u403))
    (ok (map-set ip-assets
      { asset-id: asset-id }
      (merge asset { owner: new-owner })
    ))
  )
)


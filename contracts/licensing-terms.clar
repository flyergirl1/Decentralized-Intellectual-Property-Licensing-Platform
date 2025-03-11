;; licensing-terms.clar
;; Defines usage rights and royalty structures

(define-map licenses
  { license-id: uint }
  {
    asset-id: uint,
    licensee: principal,
    royalty-rate: uint,
    expiration: uint
  }
)

(define-data-var last-license-id uint u0)

(define-read-only (get-license (license-id uint))
  (map-get? licenses { license-id: license-id })
)

(define-public (create-license (asset-id uint) (licensee principal) (royalty-rate uint) (duration uint))
  (let
    (
      (new-license-id (+ (var-get last-license-id) u1))
    )
    (var-set last-license-id new-license-id)
    (ok (map-set licenses
      { license-id: new-license-id }
      {
        asset-id: asset-id,
        licensee: licensee,
        royalty-rate: royalty-rate,
        expiration: (+ block-height duration)
      }
    ))
  )
)


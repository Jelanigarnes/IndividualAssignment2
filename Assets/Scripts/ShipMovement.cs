using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShipMovement : MonoBehaviour
{
    public float moveSpeed = 5f;    // Speed at which the object moves
    public float jumpForce = 5f;    // Force with which the object jumps
    public float groundDistance = 0.2f;    // Distance from the ground
    public float rotationSpeed = 0.5f;
    public LayerMask groundMask;    // Layer mask for the ground

    private Rigidbody rb;
    private bool isGrounded;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        // Check if the object is grounded
        isGrounded = Physics.CheckSphere(transform.position, groundDistance, groundMask);

        // Move the object using keyboard input
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");
        Vector3 movement = new Vector3(-horizontal, 0f, -vertical) * moveSpeed * Time.deltaTime;
        transform.Translate(movement, Space.Self);

        // Rotate the object based on the horizontal input
        transform.Rotate(Vector3.up, horizontal * rotationSpeed, Space.Self);

        // Jump if the object is grounded and the space bar is pressed
        if (isGrounded && Input.GetKeyDown(KeyCode.Space))
        {
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
        }
    }
}

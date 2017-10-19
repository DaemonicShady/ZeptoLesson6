using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateOnTap : MonoBehaviour {

	[SerializeField]
	private float m_angleDelta;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKey(KeyCode.LeftArrow))
			transform.Rotate(-m_angleDelta, 0.0f, 0.0f);

		if (Input.GetKey(KeyCode.RightArrow))
			transform.Rotate(m_angleDelta, 0.0f, 0.0f);

		if (Input.GetKey(KeyCode.UpArrow))
			transform.Rotate(0.0f, m_angleDelta, 0.0f);

		if (Input.GetKey(KeyCode.DownArrow))
			transform.Rotate(0.0f, -m_angleDelta, 0.0f);
	}
}

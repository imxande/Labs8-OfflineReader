/* eslint-disable prettier/prettier */
import {
	REGISTER_USER,
	LOGIN_USER,
	LOGOUT_USER,
	FETCH_DATA,
	DATA_FETCHED,
	ERROR
} from '../actions';

const initialState = {
	users: [],
	fetching: false,
	success: false,
	error: null
};

export const userReducers = (state = initialState, action) => {
	switch (action.type) {
		case FETCH_DATA:
			return { ...state, fetching: true };
		case ERROR:
			return { ...state, error: 'Error' + action.err };
		case DATA_FETCHED:
			return { ...state, notes: action.payload, fetching: false };
		case REGISTER_USER:
			const newUser = { ...action.payload };
			return {
				// not sure if this should be returned
				users: [
					...state.users,
					{
						...newUser
					}
				],
				fetching: false
			};

		default:
			return state;
	}
};
